# macOS Dev Setup

用于快速初始化 macOS 开发环境的脚本，支持按模式执行：
- 终端环境（Fish + Starship + Ghostty）
- VS Code 配置（settings + 扩展）
- 全量安装（默认）

## 配置范围

| 组件 | 内容 |
|---|---|
| Homebrew | 自动检测并安装（兼容 Apple Silicon / Intel 路径） |
| JetBrainsMono Nerd Font | 安装开发字体 |
| Fish | 安装并尝试设置为默认 shell |
| Starship | 写入 prompt 配置 |
| Ghostty | 安装并写入终端配置 |
| VS Code | 写入 `settings.json` 并安装扩展列表 |

## 快速开始

```bash
git clone https://github.com/yxm666/mac_dev_setup.git
cd mac_dev_setup
chmod +x setup-mac-dev.sh
```

## 使用方式

```bash
# 仅终端配置
./setup-mac-dev.sh terminal

# 仅 VS Code 配置
./setup-mac-dev.sh vscode

# 全量配置（默认）
./setup-mac-dev.sh
# 或
./setup-mac-dev.sh all
```

## 各模式具体行为

### `terminal`

- 执行共享步骤：检查/安装 Homebrew、安装字体
- 安装 `fish`、`starship`、`ghostty`
- 尝试把 Fish 设置为默认 shell
- 写入以下配置文件：
- `~/.config/fish/config.fish`
- `~/.config/starship.toml`
- `~/.config/ghostty/config`

### `vscode`

- 写入 `~/Library/Application Support/Code/User/settings.json`
- 安装脚本内定义的扩展列表
- 输出扩展安装成功/失败统计

### `all`

- 顺序执行 `terminal` + `vscode`

## 备份与覆盖策略

- 配置写入前会自动备份已有文件
- 备份命名格式：`<原文件名>.bak.<timestamp>`
- 这是“覆盖写入 + 自动备份”策略，不是 merge 策略

## VS Code 默认扩展列表（当前脚本）

1. `alefragnani.project-manager`
2. `anthropic.claude-code`
3. `catppuccin.catppuccin-vsc`
4. `catppuccin.catppuccin-vsc-icons`
5. `codezombiech.gitignore`
6. `dbaeumer.vscode-eslint`
7. `eamodio.gitlens`
8. `formulahendry.auto-close-tag`
9. `formulahendry.auto-rename-tag`
10. `gbodeen.partial-diff-2`
11. `github.copilot-chat`
12. `golang.go`
13. `gruntfuggly.todo-tree`
14. `humao.rest-client`
15. `ms-ceintl.vscode-language-pack-zh-hans`
16. `ms-python.debugpy`
17. `ms-python.python`
18. `ms-python.vscode-pylance`
19. `ms-python.vscode-python-envs`
20. `oderwat.indent-rainbow`
21. `thang-nm.catppuccin-perfect-icons`
22. `usernamehw.errorlens`
23. `vibe-island.terminal-focus`
24. `yzhang.markdown-all-in-one`
25. `ziyasal.vscode-open-in-github`

## 注意事项

- 终端模式执行后，建议重启终端让 Fish/Starship 生效
- 如果 Fish 路径不在 `/etc/shells`，脚本会提示手动执行 `sudo` + `chsh`
- VS Code 扩展安装依赖 `code` CLI
- 如果 `code` 不在 PATH，先在 VS Code 执行：
- `Cmd+Shift+P` -> `Shell Command: Install 'code' command in PATH`
- 脚本不会写入任何明文 token/密钥，账号登录请在各扩展内手动完成

## 常见问题

### 1. Homebrew 安装后仍提示找不到 `brew`

- 重新开一个 shell 再执行脚本
- 或手动执行：
- Apple Silicon: `eval "$(/opt/homebrew/bin/brew shellenv)"`
- Intel: `eval "$(/usr/local/bin/brew shellenv)"`

### 2. 扩展部分安装失败

- 网络不稳定或商店不可达时会失败
- 脚本会输出失败插件列表，可后续单独安装

### 3. 想回滚配置

- 使用对应 `.bak.<timestamp>` 文件恢复即可
