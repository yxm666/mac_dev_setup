#!/bin/bash
# ============================================
# macOS Dev Environment Setup Script
# Usage:
#   ./setup-mac-dev.sh terminal    - Fish + Starship + Ghostty
#   ./setup-mac-dev.sh vscode      - VS Code settings + extensions
#   ./setup-mac-dev.sh all         - Everything (default)
# ============================================

set -e

MODE="${1:-all}"

usage() {
    echo "Usage: $0 [terminal|vscode|all]"
    echo ""
    echo "  terminal  - Install & configure Fish, Starship, Ghostty"
    echo "  vscode    - Configure VS Code settings & install extensions"
    echo "  all       - Run both (default)"
    exit 1
}

if [[ "$MODE" != "terminal" && "$MODE" != "vscode" && "$MODE" != "all" ]]; then
    usage
fi

# ============================================
# Shared: Homebrew & Font
# ============================================
setup_shared() {
    # Homebrew
    if ! command -v brew &> /dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "✅ Homebrew already installed"
    fi

    # Font
    echo "🔤 Installing JetBrainsMono Nerd Font..."
    brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || echo "⚠️  Font may already be installed"
}

# ============================================
# Terminal: Fish + Starship + Ghostty
# ============================================
setup_terminal() {
    echo ""
    echo "🖥️  Setting up terminal environment..."

    # Install packages
    echo "📦 Installing Fish, Starship, Ghostty..."
    brew install fish starship

    if ! command -v ghostty &> /dev/null; then
        echo "📦 Installing Ghostty..."
        brew install --cask ghostty
    else
        echo "✅ Ghostty already installed"
    fi

    # Set Fish as default shell
    FISH_PATH=$(which fish)
    if [ "$SHELL" != "$FISH_PATH" ]; then
        echo "🐟 Setting Fish as default shell..."
        chsh -s "$FISH_PATH"
    else
        echo "✅ Fish is already default shell"
    fi

    # Configure Fish
    echo "🐟 Configuring Fish..."
    mkdir -p ~/.config/fish
    cat > ~/.config/fish/config.fish << 'FISH_EOF'
if status is-interactive
    starship init fish | source
    # Commands to run in interactive sessions can go here
end
FISH_EOF
    echo "✅ Fish configured"

    # Configure Starship
    echo "⭐ Configuring Starship..."
    mkdir -p ~/.config
    cat > ~/.config/starship.toml << 'STARSHIP_EOF'
# Starship Configuration

[aws]
symbol = "🅰 "
format = "on [$symbol($profile )(\\($region\\) )]($style)"
style = "bold blue"

[bun]
format = "via [$symbol($version )]($style)"

[c]
symbol = ""
style = "bold blue"
format = "via [$symbol$version ]($style)"

[cmake]
format = "via [$symbol($version )]($style)"

[cmd_duration]
min_time = 5000
format = "[took $duration ](bold subtext0)"

# Increase command timeout to prevent Java version check from timing out
command_timeout = 10000

[conda]
format = "[$symbol$environment ]($style)"

[dart]
format = "via [$symbol($version )]($style)"

[directory]
style = "bold yellow"
format = "[in $path ]($style)"
truncation_length = 3
truncation_symbol = "'…/'"

[docker_context]
symbol = ""
style = "bold lavender"
format = "via [$symbol ]($style)"

[elixir]
format = 'via [$symbol($version \\(OTP $otp_version\\) )]($style)'

[elm]
format = "via [$symbol($version )]($style)"

[erlang]
format = "via [$symbol($version )]($style)"

[gcloud]
format = 'on [$symbol$account(@$domain)(\\($region\\))]($style) '

[git_branch]
format = "on [$symbol$branch(:$remote_branch)]($style) "
style = "bold mauve"
symbol = "✨"

[git_status]
format = "([$all_status$ahead_behind]($style)) "
style = "bold red"
ahead = ""
behind = ""
conflicted = ""
deleted = ""
modified = ""
renamed = ""
staged = ""
stashed = ""
untracked = ""

[golang]
symbol = "🐭"
style = "bold blue"
format = "via [$symbol$version ]($style)"

[haskell]
format = "via [$symbol($version )]($style)"

[hg_branch]
format = "on [$symbol$branch]($style)"

[java]
symbol = "☕️"
style = "bold blue"
format = "via [$symbol$version ]($style)"

[julia]
format = "via [$symbol($version )]($style)"

[kotlin]
symbol = "💎"
style = "bold blue"
format = "via [$symbol$version ]($style)"

[lua]
format = "via [$symbol($version )]($style)"

[memory_usage]
format = "via [$symbol${ram}( | $swap)($system_memory) ]($style)"

[meson]
format = "via [$symbol($version )]($style)"

[nim]
format = "via [$symbol($version )]($style)"

[nix_shell]
format = "via [$symbol$state( \\($name\\))]($style) "

[nodejs]
symbol = ""
style = "bold blue"
format = "via [$symbol$version ]($style)"

[ocaml]
format = "via [$symbol($version )(\\($switch_indicator$switch_name\\) )]($style)"

[opa]
format = "via [$symbol($version )]($style)"

[openstack]
format = "on [$symbol$cloud(\\($project\\))]($style) "

[os]
format = "[$symbol]($style)"

[package]
format = "is [$symbol$version ]($style)"

[perl]
format = "via [$symbol($version )]($style)"

[php]
symbol = ""
style = "bold blue"
format = "via [$symbol$version ]($style)"

[pijul_channel]
format = "on [$symbol$branch ]($style)"

[pulumi]
format = "via [$symbol$stack]($style) "

[purescript]
format = "via [$symbol($version )]($style)"

[python]
format = 'via [${symbol}${pyenv_prefix}(${version} )(\\($virtualenv\\) )]($style)'

[raku]
format = "via [🦋 $name($version )]($style)"

[red]
format = "via [$symbol($version )]($style)"

[ruby]
format = "via [$symbol($version )]($style)"

[rust]
symbol = ""
style = "bold blue"
format = "via [$symbol$version ]($style)"

[scala]
format = "via [$symbol($version )]($style)"

[spack]
format = "via [$symbol$environment]($style) "

[sudo]
format = "[$symbol]($style)"

[swift]
format = "via [$symbol($version )]($style)"

[terraform]
format = "via [$symbol$workspace]($style) "

[time]
disabled = false
format = "at [$time]($style) "
time_format = "%H:%M"
utc_time_offset = "+8"

[username]
style_user = "bold peach"
style_root = "bold peach"
format = "[$user ]($style)"

[vagrant]
format = "via [$symbol($version )]($style)"

[vlang]
format = "via [$symbol($version )]($style)"

[zig]
format = "via [$symbol($version )]($style)"

[line_break]
disabled = false

[character]
success_symbol = '[➜](bold green)'
error_symbol = '[❯](bold red)'
STARSHIP_EOF
    echo "✅ Starship configured"

    # Configure Ghostty
    echo "👻 Configuring Ghostty..."
    mkdir -p ~/.config/ghostty
    cat > ~/.config/ghostty/config << 'GHOSTTY_EOF'
# Ghostty Configuration
# Reference: https://ghostty.org/docs/config/reference

# ============================================
# Font Settings
# ============================================
font-family = "JetBrainsMono Nerd Font"
font-size = 14

# ============================================
# Theme
# ============================================
theme = catppuccin-mocha

# ============================================
# Cursor Settings
# ============================================
cursor-style = block
cursor-invert-fg-bg = true
cursor-opacity = 0.8

# ============================================
# Window Settings
# ============================================
window-vsync = true
background-opacity = 0.95

# ============================================
# Behavior
# ============================================
copy-on-select = clipboard
link-url = true
mouse-hide-while-typing = true

# ============================================
# Appearance
# ============================================
adjust-cursor-thickness = 2
bold-is-bright = true
GHOSTTY_EOF
    echo "✅ Ghostty configured"

    echo ""
    echo "🎉 Terminal setup complete! Restart your terminal to apply changes."
}

# ============================================
# VS Code: Settings + Extensions
# ============================================
setup_vscode() {
    echo ""
    echo "📝 Setting up VS Code..."

    VSCODE_DIR="$HOME/Library/Application Support/Code/User"
    mkdir -p "$VSCODE_DIR"

    # Write settings.json
    cat > "$VSCODE_DIR/settings.json" << 'VSCODE_SETTINGS_EOF'
{
  // ========== 信任设置 ==========
  "security.workspace.trust.untrustedFiles": "open",
  // ========== Claude Code ==========
  "claudeCode.preferredLocation": "panel",
  // ========== 工作台与界面 ==========
  "workbench.colorTheme": "Catppuccin Mocha",
  "workbench.iconTheme": "catppuccin-perfect-mocha",
  "workbench.startupEditor": "none",
  "workbench.list.smoothScrolling": true,
  "workbench.editor.enablePreview": true,
  "workbench.editor.enablePreviewFromQuickOpen": true,
  "breadcrumbs.enabled": true,
  // ========== Chat 视图 ==========
  "chat.viewSessions.orientation": "stacked",
  // ========== GitLens ==========
  "gitlens.ai.model": "vscode",
  "gitlens.ai.vscode.model": "copilot:gpt-4.1",
  "aoneCopilot.userToken": "yyU8UyLdN35inZBEl5iY",
  // ========== 编辑器基础 ==========
  "editor.fontSize": 14,
  "editor.fontFamily": "'JetBrains Mono', 'Fira Code', 'Cascadia Code', Menlo, Monaco, monospace",
  "editor.fontLigatures": true,
  "editor.lineHeight": 1.6,
  "editor.minimap.enabled": false,
  "editor.cursorBlinking": "solid",
  "editor.smoothScrolling": true,
  "editor.wordWrap": "on",
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.detectIndentation": false,
  // ========== 保存与格式化 ==========
  "editor.formatOnSave": true,
  "editor.formatOnType": false,
  "editor.formatOnPaste": false,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  },
  "files.autoSave": "onFocusChange",
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "files.trimFinalNewlines": true,
  // ========== 智能提示与补全 ==========
  "editor.semanticHighlighting.enabled": true,
  "editor.suggest.showClasses": true,
  "editor.suggest.showFunctions": true,
  "editor.suggest.showVariables": true,
  "editor.suggest.showKeywords": true,
  "editor.suggest.snippetsPreventQuickSuggestions": false,
  "editor.quickSuggestions": {
    "other": "on",
    "comments": "off",
    "strings": "off"
  },
  "editor.inlineSuggest.enabled": true,
  "editor.suggest.preview": true,
  "editor.suggestSelection": "first",
  // ========== 括号与引号 ==========
  "editor.autoClosingBrackets": "always",
  "editor.autoClosingQuotes": "always",
  "editor.autoClosingDelete": "always",
  "editor.autoClosingOvertype": "always",
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": "active",
  // ========== 终端配置 ==========
  "terminal.integrated.defaultProfile.osx": "fish",
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.fontFamily": "'JetBrains Mono', Menlo, monospace",
  "terminal.integrated.scrollback": 10000,
  "terminal.integrated.cursorBlinking": false,
  "terminal.integrated.cursorStyle": "line",
  "terminal.integrated.sendKeyBindingsToShell": true,
  // ========== Git 集成 ==========
  "git.autofetch": true,
  "git.confirmSync": false,
  "git.enableSmartCommit": true,
  "git.pruneOnFetch": true,
  "git.branchSortOrder": "committerdate",
  // ========== 性能与隐私 ==========
  "telemetry.telemetryLevel": "off",
  "update.mode": "manual",
  "extensions.autoCheckUpdates": false,
  "extensions.autoUpdate": false,
  "search.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/build": true,
    "**/.git": true,
    "**/__pycache__": true,
    "**/*.pyc": true,
    "**/vendor": true,
    "**/go.sum": true
  },
  "files.watcherExclude": {
    "**/node_modules/**": true,
    "**/dist/**": true,
    "**/build/**": true,
    "**/.git/**": true,
    "**/__pycache__/**": true
  },
  // ========== Python 配置 ==========
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff",
    "editor.tabSize": 4,
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit"
    },
    "editor.formatOnSave": true,
    "editor.rulers": [
      88,
      120
    ],
    "python.analysis.typeCheckingMode": "basic",
    "python.analysis.autoImportCompletions": true,
    "python.languageServer": "Pylance",
    "python.testing.pytestEnabled": true,
    "jupyter.notebookFileRoot": "${fileDirname}"
  },
  // ========== Go 配置 ==========
  "[go]": {
    "editor.defaultFormatter": "golang.go",
    "editor.tabSize": 4,
    "editor.insertSpaces": false,
    "editor.formatOnSave": true,
    "editor.rulers": [
      120
    ],
    "go.buildFlags": [],
    "go.lintFlags": [
      "--fast"
    ],
    "go.testFlags": [
      "-v",
      "-race"
    ],
    "go.useLanguageServer": true,
    "gopls": {
      "ui.semanticTokens": true,
      "ui.completion.usePlaceholders": true,
      "ui.diagnostic.analyses": {
        "unusedparams": true,
        "shadow": true,
        "nilness": true,
        "unusedwrite": true,
        "useany": true
      },
      "ui.modulediagnostics": true
    }
  },
  // ========== JavaScript 配置 ==========
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2,
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": "explicit"
    },
    "javascript.updateImportsOnFileMove.enabled": "always",
    "javascript.suggest.completeFunctionCalls": true,
    "javascript.suggest.includeAutomaticOptionalChainCompletions": true
  },
  // ========== TypeScript 配置 ==========
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2,
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": "explicit",
      "source.organizeImports": "explicit"
    },
    "typescript.updateImportsOnFileMove.enabled": "always",
    "typescript.suggest.completeFunctionCalls": true,
    "typescript.suggest.includeAutomaticOptionalChainCompletions": true,
    "typescript.tsserver.log": "off"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2,
    "editor.formatOnSave": true
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2,
    "editor.quickSuggestions": {
      "strings": true
    }
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2,
    "editor.autoClosingBrackets": "always"
  },
  "[css]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2,
    "editor.autoClosingBrackets": "always"
  },
  "[markdown]": {
    "editor.tabSize": 2,
    "editor.wordWrap": "on",
    "markdown.preview.breaks": true,
    "markdown.validate.enabled": true
  },
  "[yaml]": {
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "editor.autoClosingBrackets": "never"
  },
  "[shellscript]": {
    "editor.tabSize": 2,
    "editor.insertSpaces": true
  },
  // ========== 建议补充配置 ==========
  // Error Lens - 行内显示错误,无需 hover
  "errorLens.enabledDiagnosticLevels": [
    "error",
    "warning",
    "info"
  ],
  "errorLens.delayMs": 300,
  // Bracket Colorization - 增强嵌套层次可读性
  "workbench.colorCustomizations": {
    "editorBracketHighlight.foreground1": "#FF6B6B",
    "editorBracketHighlight.foreground2": "#4ECDC4",
    "editorBracketHighlight.foreground3": "#45B7D1",
    "editorBracketHighlight.foreground4": "#96CEB4",
    "editorBracketHighlight.foreground5": "#FFEAA7",
    "editorBracketHighlight.foreground6": "#DDA0DD"
  },
  // 智能 Suggestions
  "editor.suggest.filterGraceful": true,
  "editor.suggest.localityBonus": true,
  "editor.suggest.shareSuggestSelections": true,
  // Accept Suggestion on Enter
  "editor.acceptSuggestionOnEnter": "smart",
  // Emmet 支持 (HTML/CSS 快速编写)
  "emmet.triggerExpansionOnTab": true,
  "emmet.includeLanguages": {
    "vue-html": "html",
    "plaintext": "html"
  },
  // Link Editing - 自动更新配对的标签/引用
  "editor.linkedEditing": true,
  // Peek Definition - 在不跳转的情况下查看定义
  "editor.peekDefinitionDefault": "peekAndDismiss",
  "git.mergeEditor": true,
  "diffEditor.renderIndicators": false,
  "diffEditor.maxComputationTime": 20000
}
VSCODE_SETTINGS_EOF
    echo "✅ VS Code settings configured"

    # Install extensions
    echo "📦 Installing VS Code extensions..."
    EXTENSIONS=(
        "alefragnani.project-manager"
        "anthropic.claude-code"
        "aone.aone-copilot"
        "catppuccin.catppuccin-vsc"
        "catppuccin.catppuccin-vsc-icons"
        "codezombiech.gitignore"
        "dbaeumer.vscode-eslint"
        "eamodio.gitlens"
        "formulahendry.auto-close-tag"
        "formulahendry.auto-rename-tag"
        "gbodeen.partial-diff-2"
        "github.copilot-chat"
        "golang.go"
        "gruntfuggly.todo-tree"
        "humao.rest-client"
        "ms-ceintl.vscode-language-pack-zh-hans"
        "ms-python.debugpy"
        "ms-python.python"
        "ms-python.vscode-pylance"
        "ms-python.vscode-python-envs"
        "oderwat.indent-rainbow"
        "thang-nm.catppuccin-perfect-icons"
        "usernamehw.errorlens"
        "vibe-island.terminal-focus"
        "yzhang.markdown-all-in-one"
        "ziyasal.vscode-open-in-github"
    )

    for ext in "${EXTENSIONS[@]}"; do
        echo "  Installing $ext..."
        code --install-extension "$ext" --force 2>/dev/null || echo "  ⚠️  Failed to install $ext"
    done
    echo "✅ VS Code extensions installed"

    echo ""
    echo "🎉 VS Code setup complete!"
}

# ============================================
# Main
# ============================================
echo "🚀 macOS Dev Environment Setup"
echo "   Mode: $MODE"

if [[ "$MODE" == "all" || "$MODE" == "terminal" ]]; then
    setup_shared
    setup_terminal
fi

if [[ "$MODE" == "all" || "$MODE" == "vscode" ]]; then
    setup_vscode
fi

echo ""
echo "🎉 All done!"
