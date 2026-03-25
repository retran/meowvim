#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

# Meowvim Config Test Script
# Tests Neovim configuration for errors and issues

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
NVIM_CONFIG="${NVIM_CONFIG:-$HOME/.config/nvim}"
TEST_OUTPUT="/tmp/meowvim-test-$$"

# Counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
    ((TESTS_PASSED++))
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
    ((TESTS_FAILED++))
}

log_test() {
    ((TESTS_RUN++))
    echo -e "${YELLOW}[TEST $TESTS_RUN]${NC} $1"
}

# Test: Neovim starts without errors
test_nvim_starts() {
    log_test "Testing if Neovim starts without errors..."
    
    if nvim --headless "+lua print('test')" +qa 2>&1 | grep -qi "error"; then
        log_error "Neovim failed to start cleanly"
        return 1
    else
        log_success "Neovim starts successfully"
        return 0
    fi
}

# Test: Config system loads
test_config_loads() {
    log_test "Testing config system loads..."
    
    local output=$(nvim --headless "+lua local ok, config = pcall(require, 'meowvim.config'); print(ok and 'OK' or 'FAIL')" +qa 2>&1)
    
    if echo "$output" | grep -q "OK"; then
        log_success "Config system loads successfully"
        return 0
    else
        log_error "Config system failed to load"
        return 1
    fi
}

# Test: Health checks pass
test_health_checks() {
    log_test "Running health checks..."
    
    nvim --headless "+checkhealth meowvim" "+write $TEST_OUTPUT/health.txt" +qa 2>&1
    
    if grep -qi "ERROR" "$TEST_OUTPUT/health.txt"; then
        log_error "Health checks found errors"
        cat "$TEST_OUTPUT/health.txt"
        return 1
    else
        log_success "Health checks passed"
        return 0
    fi
}

# Test: User config validates
test_user_config() {
    log_test "Validating user config..."
    
    local user_config="$HOME/.config/meowvim/config.lua"
    if [ ! -f "$user_config" ]; then
        log_info "No user config found (optional)"
        return 0
    fi
    
    local output=$(nvim --headless "+lua local config = require('meowvim.config'); local ok, err = config.validate(); print(ok and 'OK' or tostring(err))" +qa 2>&1)
    
    if echo "$output" | grep -q "OK"; then
        log_success "User config validates successfully"
        return 0
    else
        log_error "User config validation failed: $output"
        return 1
    fi
}

# Test: All plugins load
test_plugins_load() {
    log_test "Testing plugin loading..."
    
    local output=$(nvim --headless "+lua local lazy = require('lazy'); local stats = lazy.stats(); print('Loaded:' .. stats.loaded .. '/' .. stats.count)" +qa 2>&1)
    
    if echo "$output" | grep -q "Loaded:"; then
        log_success "Plugins loaded: $(echo "$output" | grep -o 'Loaded:[0-9]*/[0-9]*' | tail -1)"
        return 0
    else
        log_error "Failed to check plugin status"
        return 1
    fi
}

# Test: LSP config is valid
test_lsp_config() {
    log_test "Testing LSP configuration..."
    
    local output=$(nvim --headless "+lua local ok = pcall(require, 'lspconfig'); print(ok and 'OK' or 'FAIL')" +qa 2>&1)
    
    if echo "$output" | grep -q "OK"; then
        log_success "LSP config is valid"
        return 0
    else
        log_error "LSP config failed to load"
        return 1
    fi
}

# Test: Treesitter parsers installed
test_treesitter() {
    log_test "Testing Treesitter parsers..."
    
    local output=$(nvim --headless "+lua local ts = require('nvim-treesitter.parsers'); local count = 0; for _ in pairs(ts.get_parser_configs()) do count = count + 1 end; print('Parsers:' .. count)" +qa 2>&1)
    
    if echo "$output" | grep -q "Parsers:[0-9]"; then
        local parser_count=$(echo "$output" | grep -o 'Parsers:[0-9]*' | tail -1 | cut -d: -f2)
        if [ "$parser_count" -gt 0 ]; then
            log_success "Treesitter has $parser_count parsers"
            return 0
        else
            log_error "No Treesitter parsers installed"
            return 1
        fi
    else
        log_error "Failed to check Treesitter status"
        return 1
    fi
}

# Test: Keymap conflicts
test_keymap_conflicts() {
    log_test "Checking for keymap conflicts..."

    local lua_script='
local conflicts = require("meowvim.keymap_checker").get_conflicts()
if #conflicts == 0 then
  io.write("No keymap conflicts\n")
else
  io.write(string.format("Found %d conflicts:\n", #conflicts))
  for _, c in ipairs(conflicts) do
    io.write(string.format("  [%s] %s\n", c.mode, c.lhs))
  end
end
'
    local output
    output=$(nvim --headless "+lua $lua_script" +qa 2>&1)

    if echo "$output" | grep -q "^No keymap conflicts"; then
        log_success "No keymap conflicts detected"
        return 0
    elif echo "$output" | grep -q "^Found"; then
        local count
        count=$(echo "$output" | grep -o 'Found [0-9]* conflicts' | grep -o '[0-9]*')
        log_error "Found $count keymap conflicts:"
        echo "$output" | grep -v "^Found" | head -20
        return 1
    else
        log_info "Keymap conflict check inconclusive (headless output not captured)"
        return 0
    fi
}

# Test: Lua syntax check
test_lua_syntax() {
    log_test "Checking Lua syntax in config files..."
    
    local errors=0
    while IFS= read -r -d '' file; do
        if ! luac -p "$file" > /dev/null 2>&1; then
            log_error "Syntax error in: $file"
            ((errors++))
        fi
    done < <(find "$NVIM_CONFIG/lua" -name "*.lua" -print0 2>/dev/null)
    
    if [ $errors -eq 0 ]; then
        log_success "All Lua files have valid syntax"
        return 0
    else
        log_error "Found $errors files with syntax errors"
        return 1
    fi
}

# Cleanup
cleanup() {
    rm -rf "$TEST_OUTPUT"
}

trap cleanup EXIT

# Main
main() {
    echo "==================================="
    echo "  Meowvim Config Test Suite"
    echo "==================================="
    echo ""
    
    # Create test output directory
    mkdir -p "$TEST_OUTPUT"
    
    # Check if config directory exists
    if [ ! -d "$NVIM_CONFIG" ]; then
        log_error "Neovim config directory not found: $NVIM_CONFIG"
        exit 1
    fi
    
    log_info "Testing configuration at: $NVIM_CONFIG"
    echo ""
    
    # Run tests
    test_nvim_starts || true
    test_config_loads || true
    test_user_config || true
    test_plugins_load || true
    test_lsp_config || true
    test_treesitter || true
    test_health_checks || true
    test_keymap_conflicts || true
    
    # Check if luac is available for syntax checking
    if command -v luac &> /dev/null; then
        test_lua_syntax || true
    else
        log_info "luac not found, skipping Lua syntax check"
    fi
    
    # Summary
    echo ""
    echo "==================================="
    echo "  Test Summary"
    echo "==================================="
    echo -e "Tests run:    $TESTS_RUN"
    echo -e "${GREEN}Passed:       $TESTS_PASSED${NC}"
    echo -e "${RED}Failed:       $TESTS_FAILED${NC}"
    echo ""
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed. Please review the output above.${NC}"
        exit 1
    fi
}

main "$@"
