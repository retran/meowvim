#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

# Meowvim Update Script
# Updates plugins and creates backup with rollback capability

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
NVIM_CONFIG="${NVIM_CONFIG:-$HOME/.config/nvim}"
BACKUP_DIR="${NVIM_BACKUP_DIR:-$HOME/.local/share/nvim/backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="$BACKUP_DIR/backup_$TIMESTAMP"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backup
create_backup() {
    log_info "Creating backup at $BACKUP_PATH..."
    mkdir -p "$BACKUP_DIR"
    
    # Backup lazy.nvim data
    if [ -d "$HOME/.local/share/nvim/lazy" ]; then
        cp -r "$HOME/.local/share/nvim/lazy" "$BACKUP_PATH/lazy"
        log_success "Backed up lazy.nvim plugins"
    fi
    
    # Backup lazy-lock.json
    if [ -f "$NVIM_CONFIG/lazy-lock.json" ]; then
        cp "$NVIM_CONFIG/lazy-lock.json" "$BACKUP_PATH/lazy-lock.json"
        log_success "Backed up lazy-lock.json"
    fi
    
    # Save backup info
    cat > "$BACKUP_PATH/info.txt" <<EOF
Meowvim Backup
Created: $(date)
Timestamp: $TIMESTAMP
Config: $NVIM_CONFIG
EOF
    
    log_success "Backup created successfully"
}

# Rollback to backup
rollback() {
    local backup_to_restore="$1"
    
    if [ -z "$backup_to_restore" ]; then
        log_error "No backup path specified for rollback"
        exit 1
    fi
    
    if [ ! -d "$backup_to_restore" ]; then
        log_error "Backup not found: $backup_to_restore"
        exit 1
    fi
    
    log_warning "Rolling back to backup: $backup_to_restore"
    
    # Restore lazy.nvim plugins
    if [ -d "$backup_to_restore/lazy" ]; then
        rm -rf "$HOME/.local/share/nvim/lazy"
        cp -r "$backup_to_restore/lazy" "$HOME/.local/share/nvim/lazy"
        log_success "Restored lazy.nvim plugins"
    fi
    
    # Restore lazy-lock.json
    if [ -f "$backup_to_restore/lazy-lock.json" ]; then
        cp "$backup_to_restore/lazy-lock.json" "$NVIM_CONFIG/lazy-lock.json"
        log_success "Restored lazy-lock.json"
    fi
    
    log_success "Rollback completed"
}

# Update plugins
update_plugins() {
    log_info "Updating plugins..."
    
    nvim --headless "+Lazy! sync" +qa
    
    if [ $? -eq 0 ]; then
        log_success "Plugins updated successfully"
    else
        log_error "Plugin update failed"
        return 1
    fi
}

# Run health checks
health_check() {
    log_info "Running health checks..."
    
    nvim --headless "+checkhealth meowvim" "+write /tmp/meowvim-health.txt" +qa 2>&1
    
    if grep -q "ERROR" /tmp/meowvim-health.txt; then
        log_warning "Health check found errors. Review: /tmp/meowvim-health.txt"
        return 1
    else
        log_success "Health checks passed"
        return 0
    fi
}

# Clean old backups (keep last 10)
cleanup_old_backups() {
    log_info "Cleaning up old backups..."
    
    cd "$BACKUP_DIR" || return
    ls -t | tail -n +11 | xargs -I {} rm -rf {}
    
    log_success "Old backups cleaned"
}

# Main
main() {
    echo "==================================="
    echo "  Meowvim Update Script"
    echo "==================================="
    echo ""
    
    # Check if rollback requested
    if [ "$1" = "--rollback" ]; then
        if [ -z "$2" ]; then
            log_info "Available backups:"
            ls -lt "$BACKUP_DIR" | grep "^d" | awk '{print $NF}'
            echo ""
            echo "Usage: $0 --rollback <backup_timestamp>"
            echo "Example: $0 --rollback backup_20250130_123456"
            exit 0
        fi
        rollback "$BACKUP_DIR/$2"
        exit 0
    fi
    
    # Check if config directory exists
    if [ ! -d "$NVIM_CONFIG" ]; then
        log_error "Neovim config directory not found: $NVIM_CONFIG"
        exit 1
    fi
    
    # Create backup
    create_backup
    
    # Update plugins
    if ! update_plugins; then
        log_error "Update failed. Rolling back..."
        rollback "$BACKUP_PATH"
        exit 1
    fi
    
    # Run health check
    if ! health_check; then
        log_warning "Health check failed, but update completed"
        log_info "To rollback: $0 --rollback backup_$TIMESTAMP"
    fi
    
    # Cleanup old backups
    cleanup_old_backups
    
    echo ""
    log_success "Update completed successfully!"
    log_info "Backup saved at: $BACKUP_PATH"
    log_info "To rollback: $0 --rollback backup_$TIMESTAMP"
}

main "$@"
