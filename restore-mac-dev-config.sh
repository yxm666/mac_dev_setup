#!/bin/bash

set -euo pipefail

ALL_TARGET_KEYS=(fish fish_migration starship ghostty vscode)

usage() {
    cat <<'EOF'
Restore helper for mac_dev_setup backups.

Usage:
  ./restore-mac-dev-config.sh list [target|all]
  ./restore-mac-dev-config.sh restore-latest [target|all]
  ./restore-mac-dev-config.sh restore-file <backup-file>

Targets:
  fish            -> ~/.config/fish/config.fish
  fish_migration  -> ~/.config/fish/conf.d/90-zsh-migration.fish
  starship        -> ~/.config/starship.toml
  ghostty         -> ~/.config/ghostty/config
  vscode          -> ~/Library/Application Support/Code/User/settings.json
  all             -> all targets above
EOF
}

target_path_for_key() {
    local key="$1"
    case "$key" in
        fish) echo "$HOME/.config/fish/config.fish" ;;
        fish_migration) echo "$HOME/.config/fish/conf.d/90-zsh-migration.fish" ;;
        starship) echo "$HOME/.config/starship.toml" ;;
        ghostty) echo "$HOME/.config/ghostty/config" ;;
        vscode) echo "$HOME/Library/Application Support/Code/User/settings.json" ;;
        *) return 1 ;;
    esac
}

list_backups_for_path() {
    local target_path="$1"
    ls -1t "${target_path}.bak."* 2>/dev/null || true
}

print_target_backups() {
    local key="$1"
    local target_path backups

    if ! target_path="$(target_path_for_key "$key")"; then
        echo "❌ Unknown target: $key"
        return 1
    fi

    backups="$(list_backups_for_path "$target_path")"
    echo ""
    echo "[$key] $target_path"
    if [[ -z "$backups" ]]; then
        echo "  (no backups found)"
        return 0
    fi

    while IFS= read -r line; do
        echo "  - $line"
    done <<< "$backups"
}

restore_backup_file() {
    local backup_file="$1"
    local target_path

    if [[ ! -f "$backup_file" ]]; then
        echo "❌ Backup file not found: $backup_file"
        exit 1
    fi

    if [[ "$backup_file" =~ ^(.+)\.bak\.[0-9]{14}$ ]]; then
        target_path="${BASH_REMATCH[1]}"
    else
        echo "❌ Invalid backup file name: $backup_file"
        echo "   Expected suffix: .bak.YYYYMMDDHHMMSS"
        exit 1
    fi

    mkdir -p "$(dirname "$target_path")"
    cp "$backup_file" "$target_path"
    echo "✅ Restored: $backup_file -> $target_path"
}

restore_latest_for_key() {
    local key="$1"
    local target_path latest_backup

    if ! target_path="$(target_path_for_key "$key")"; then
        echo "❌ Unknown target: $key"
        exit 1
    fi

    latest_backup="$(list_backups_for_path "$target_path" | head -n 1 || true)"
    if [[ -z "$latest_backup" ]]; then
        echo "⚠️  No backup found for $key ($target_path), skipped."
        return 0
    fi

    restore_backup_file "$latest_backup"
}

main() {
    local command="${1:-help}"
    local target="${2:-all}"
    local key

    case "$command" in
        list)
            if [[ "$target" == "all" ]]; then
                for key in "${ALL_TARGET_KEYS[@]}"; do
                    print_target_backups "$key"
                done
            else
                print_target_backups "$target"
            fi
            ;;
        restore-latest)
            if [[ "$target" == "all" ]]; then
                for key in "${ALL_TARGET_KEYS[@]}"; do
                    restore_latest_for_key "$key"
                done
            else
                restore_latest_for_key "$target"
            fi
            ;;
        restore-file)
            if [[ $# -lt 2 ]]; then
                echo "❌ Missing backup-file."
                usage
                exit 1
            fi
            restore_backup_file "$2"
            ;;
        help|-h|--help)
            usage
            ;;
        *)
            echo "❌ Unknown command: $command"
            usage
            exit 1
            ;;
    esac
}

main "$@"
