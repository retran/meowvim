#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

# Updates the plugins and keeps a restore point.
#
# The restore point is lazy-lock.json, not a copy of the plugin directory.
# lazy.nvim pins every plugin to a commit in that file, so putting an older
# copy back and running `:Lazy! restore` returns the exact versions, and a
# lock file is a few kilobytes where the plugin directory is hundreds of
# megabytes.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

NVIM_CONFIG="${NVIM_CONFIG:-$HOME/.config/nvim}"
BACKUP_DIR="${NVIM_BACKUP_DIR:-$HOME/.local/share/nvim/backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_$TIMESTAMP"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
KEEP_BACKUPS=10

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

create_backup() {
    local lock="$NVIM_CONFIG/lazy-lock.json"

    if [ ! -f "$lock" ]; then
        log_error "No lazy-lock.json in $NVIM_CONFIG, so there is nothing to restore to"
        exit 1
    fi

    log_info "Creating restore point at $BACKUP_PATH"
    mkdir -p "$BACKUP_PATH"
    cp "$lock" "$BACKUP_PATH/lazy-lock.json"

    cat > "$BACKUP_PATH/info.txt" <<EOF
Meowvim restore point
Created: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Timestamp: $TIMESTAMP
Config: $NVIM_CONFIG
Neovim: $(nvim --version | head -1)
EOF

    log_success "Restore point created"
}

rollback() {
    local backup="$1"

    if [ ! -d "$backup" ]; then
        log_error "Restore point not found: $backup"
        exit 1
    fi

    if [ ! -f "$backup/lazy-lock.json" ]; then
        log_error "Restore point has no lazy-lock.json: $backup"
        exit 1
    fi

    log_warning "Rolling back to $backup"
    cp "$backup/lazy-lock.json" "$NVIM_CONFIG/lazy-lock.json"
    nvim --headless "+Lazy! restore" +qa
    log_success "Plugins restored to the pinned versions"
}

update_plugins() {
    log_info "Updating plugins"
    nvim --headless "+Lazy! sync" +qa
    log_success "Plugins updated"
}

# The health report marks its own failures with a cross. A plain "ERROR" also
# appears inside warning texts, such as the message a mise shim prints when no
# version is set, so match the marker.
health_check() {
    local report=/tmp/meowvim-health.txt

    log_info "Running health checks"
    nvim --headless "+checkhealth meowvim" "+write! $report" +qa

    if grep -q "❌ ERROR" "$report"; then
        log_warning "Health checks reported errors. Read $report"
        return 1
    fi

    log_success "Health checks passed"
}

cleanup_old_backups() {
    local stale
    stale=$(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -name 'backup_*' | sort -r | tail -n "+$((KEEP_BACKUPS + 1))")

    if [ -z "$stale" ]; then
        return
    fi

    log_info "Removing restore points older than the last $KEEP_BACKUPS"
    echo "$stale" | while read -r dir; do rm -rf "$dir"; done
}

list_backups() {
    if [ ! -d "$BACKUP_DIR" ]; then
        log_info "No restore points yet"
        return
    fi

    log_info "Available restore points:"
    find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -name 'backup_*' -exec basename {} \; | sort -r
}

main() {
    echo "==================================="
    echo "  Meowvim update"
    echo "==================================="
    echo ""

    if [ "${1:-}" = "--rollback" ]; then
        if [ -z "${2:-}" ]; then
            list_backups
            echo ""
            echo "Usage: $0 --rollback <backup_timestamp>"
            echo "Example: $0 --rollback backup_20260918_123456"
            exit 0
        fi
        rollback "$BACKUP_DIR/$2"
        exit 0
    fi

    if [ ! -d "$NVIM_CONFIG" ]; then
        log_error "Neovim config directory not found: $NVIM_CONFIG"
        exit 1
    fi

    create_backup

    if ! update_plugins; then
        log_error "Update failed, rolling back"
        rollback "$BACKUP_PATH"
        exit 1
    fi

    if ! health_check; then
        log_warning "Update finished, but the health report has errors"
        log_info "To roll back: $0 --rollback $BACKUP_NAME"
    fi

    cleanup_old_backups

    echo ""
    log_success "Update complete"
    log_info "Restore point: $BACKUP_PATH"
    log_info "To roll back: $0 --rollback $BACKUP_NAME"
}

main "$@"
