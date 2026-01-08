# lvim

这是一个 Neovim 配置项目，建议将其克隆到 `~/.config` 目录下，并命名为 `lvim`。

## 安装

在终端中执行以下命令：

```bash
git clone git@github.com:Yangeyu/lvim-config.git ~/.config/lvim
```

## 使用

1. 确保你已经安装了 [Neovim](https://neovim.io/)（推荐 0.11.5 及以上版本）。
2. 启动 Neovim：
   ```bash
   nvim
   ```
3. lvim 配置会自动生效。

## 目录结构

```
tree -a -I 'session|.claude|.git'
~/.config/lvim/
 ├── .config
 │   └── prompts
 │       ├── complete-code.md
 │       └── gen-comment.md
 ├── .gitignore
 ├── config.lua
 ├── lazy-lock.json
 └── README.md`
``
