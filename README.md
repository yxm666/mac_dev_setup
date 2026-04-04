# macOS Dev Setup

一键配置 macOS 开发环境的启动脚本。

## 配置内容

| 工具 | 说明 |
|------|------|
| **Fish Shell** | 默认 shell，交互式体验 |
| **Starship** | 跨 shell 的 prompt 主题 |
| **Ghostty** | 现代化终端模拟器 |
| **VS Code** | 编辑器配置 + 扩展自动安装 |
| **JetBrainsMono Nerd Font** | 开发字体 |

## 快速开始

```bash
# 克隆仓库
git clone <your-repo-url>
cd mac-dev-setup

# 赋予执行权限并运行
chmod +x setup-mac-dev.sh
./setup-mac-dev.sh
```

## 脚本做了什么

1. **Homebrew** — 未安装则自动安装
2. **包管理** — 安装 Fish、Starship、Ghostty
3. **Shell** — 将 Fish 设为默认 shell
4. **配置文件** — 写入 `~/.config/fish/config.fish`、`~/.config/starship.toml`、`~/.config/ghostty/config`
5. **VS Code** — 写入 `settings.json` 并批量安装扩展
6. **字体** — 安装 JetBrainsMono Nerd Font

## 自定义

脚本内所有配置文件都使用 heredoc 写入，你可以直接修改对应段落：

- **Ghostty 主题/字体** → 编辑脚本中 `GHOSTTY_EOF` 部分
- **Starship prompt** → 编辑 `STARSHIP_EOF` 部分
- **VS Code 设置** → 编辑 `VSCODE_SETTINGS_EOF` 部分
- **扩展列表** → 编辑 `EXTENSIONS` 数组

## 注意事项

- 运行后需要**重启终端**让 Fish 和 Starship 生效
- VS Code 扩展安装依赖 `code` CLI，如果没找到需要先打开 VS Code 安装 command line tool（`Cmd+Shift+P` → `Shell Command: Install 'code' command in PATH`）
- 脚本中包含的 token/密钥（如 Copilot token）建议在新机器上确认有效性
