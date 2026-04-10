# macOS Dev Setup

一键配置 macOS 开发环境的启动脚本。支持按需选择安装终端配置或 VS Code 配置。

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
git clone https://github.com/yxm666/mac_dev_setup.git
cd mac_dev_setup

# 赋予执行权限
chmod +x setup-mac-dev.sh
```

## 使用方式

脚本支持三种模式，按需选择：

### 1. 终端配置（Fish + Starship + Ghostty）

```bash
./setup-mac-dev.sh terminal
```

安装 Fish shell、Starship prompt、Ghostty 终端，并写入配置文件。

### 2. VS Code 配置

```bash
./setup-mac-dev.sh vscode
```

写入 VS Code `settings.json` 并批量安装扩展。

### 3. 全部配置（默认）

```bash
./setup-mac-dev.sh
# 或
./setup-mac-dev.sh all
```

同时执行终端配置和 VS Code 配置。

## 注意事项

- 运行终端配置后需要**重启终端**让 Fish 和 Starship 生效
- 配置文件写入前会自动备份（例如 `settings.json.bak.<timestamp>`）
- 如果 Fish 未在 `/etc/shells` 中，脚本会提示你手动执行 `sudo` + `chsh`
- VS Code 扩展安装依赖 `code` CLI，如果没找到需要先打开 VS Code 安装 command line tool（`Cmd+Shift+P` → `Shell Command: Install 'code' command in PATH`）
- 脚本不会写入任何明文 token/密钥，请在扩展中手动登录
