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
| Fish | 幂等安装并尝试设置为默认 shell |
| Starship | 写入 prompt 配置 |
| Ghostty | 幂等安装并写入终端配置（`Catppuccin Mocha`） |
| Zsh -> Fish 迁移 | best-effort 迁移常见 `export` / `PATH` / `alias` |
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
- 幂等检查并安装 `fish`、`starship`、`ghostty`（已安装则跳过）
- 尝试把 Fish 设置为默认 shell（基于真实登录 shell 检测）
- 生成 `~/.config/fish/conf.d/90-zsh-migration.fish`，迁移常见 zsh 配置（best-effort）
- 检查 `starship` preset `catppuccin-powerline` 是否可用
- 写入以下配置文件：
- `~/.config/fish/config.fish`
- `~/.config/starship.toml`
- `~/.config/ghostty/config`
- 终端任务完成后打印：
- `Terminal status`（shell / fish / starship / preset / ghostty theme）
- `Terminal changes summary`（本次变更清单及功能）

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

## 幂等说明

- `terminal` 模式下：
- `fish`、`starship` 使用 `brew list --formula` 检查后再安装
- `ghostty` 使用 `brew list --cask` 检查后再安装
- 已安装时会显示 `skip`，并在结尾汇总到 `Terminal changes summary`
- 配置文件仍会按“备份后覆盖写入”执行，保证结果一致

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

### 4. 从 zsh 切到 fish 能 1:1 迁移吗？

- 不能严格 1:1（两者语法、插件生态、启动机制不同）
- 脚本会做 best-effort 迁移：`export`、`PATH`、`alias`
- 复杂函数、插件框架、`compinit`/`bindkey` 等需手动调整

### 5. 报错 `theme "catppuccin-mocha" not found` 怎么办？

- 新脚本会写入 Ghostty 主题：`theme = "Catppuccin Mocha"`
- 这是 Ghostty 内置主题名，避免自定义主题目录缺失导致报错

### 6. `starship` 的 `catppuccin-powerline` 需要单独安装吗？

- 不需要，属于 `starship` 内置 preset
- 脚本会自动检测是否可用并输出结果
