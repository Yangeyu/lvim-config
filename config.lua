-- Discord: https://discord.com/invite/Xb9B4Ny
local opts       = { noremap = true, silent = true }
local keymap     = vim.api.nvim_set_keymap
local autocmd    = vim.api.nvim_create_autocmd

-- Backfill position_encoding for plugins still using the old LSP helper signature.
local make_position_params = vim.lsp.util.make_position_params

vim.lsp.util.make_position_params = function(window, position_encoding)
  local bufnr = window and window ~= 0 and vim.api.nvim_win_is_valid(window)
      and vim.api.nvim_win_get_buf(window)
    or vim.api.nvim_get_current_buf()
  local client = vim.lsp.get_clients { bufnr = bufnr }[1]
  return make_position_params(window, position_encoding or (client and client.offset_encoding))
end

-- 内建 ftplugin 会给 markdown 强设 4 格缩进，关掉以回落到全局的 2
vim.g.markdown_recommended_style = 0

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldopen:remove("search") -- set foldopen-=search

lvim.colorscheme = "catppuccin-mocha"
keymap("v", "<space>a=", ":EasyAlign *=<CR>", opts)
keymap("v", "<space>a,", ":EasyAlign */,/<CR>", opts)
keymap("i", "<C-E>", "<Plug>luasnip-next-choice", opts)
keymap("i", "<C-U>", "<cmd>lua require('luasnip.extras.select_choice')()<cr>", opts)
keymap("i", "jj", "<Esc>", opts)
keymap("i", "kk", "<Esc>", opts)
keymap("i", ";a", "<Esc>la", opts)
keymap("i", ";A", "<Esc>A", opts)
keymap("n", "j", "gj", opts)
keymap("n", "k", "gk", opts)
keymap("n", "<space>pp", '"0p', opts)
keymap("v", "<space>pp", '"0p', opts)
keymap("v", "<space>f", "y/<C-r>\"<CR>", opts)
keymap("v", "<space>c", "g<C-g>", opts)
keymap("n", "<S-l>", ":BufferLineCycleNext<CR>", opts)
keymap("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "<C-p>", ":BufferLineMovePrev<CR>", opts)
keymap("n", "<C-n>", ":BufferLineMoveNext<CR>", opts)
keymap("n", "<space>gv", "ggVG", opts)
keymap("n", "<space>Q", ":qall<CR>", opts)
keymap("n", "<space>tv", ":ToggleTerm direction=vertical size=70<CR>", opts)
keymap("n", "<space>tt", ":ToggleTerm direction=float<CR>", opts)
keymap("n", "<space>tj", ":NvimTreeFocus<CR>", opts)

lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.indentlines.options.use_treesitter = true
lvim.builtin.indentlines.options.context_patterns = {
  "^if", "do_block", "function", "class", "method", "while",
  "for", "try", "catch", "with", "except", "arguments", "argument_list",
  "object", "dictionary", "element", "table", "tuple",
}

lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.autotag.enable = true
lvim.builtin.illuminate.options.providers = { "lsp", "regex" }

-- 状态栏宏录制指示器：录制期间常驻显示 "● REC @寄存器"，结束后自动消失
-- config.lua 执行时默认分区尚未填充（lualine_x 为 nil），需连同默认组件一起显式设置
local lualine_components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_x = {
  {
    function()
      local reg = vim.fn.reg_recording()
      if reg == "" then
        return ""
      end
      return "● REC @" .. reg
    end,
    color = { fg = "#ff5555", gui = "bold" },
  },
  lualine_components.diagnostics,
  lualine_components.lsp,
  lualine_components.spaces,
  lualine_components.filetype,
}
-- 录制开始/结束不会自动触发 statusline 重绘，需手动刷新
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    require("lualine").refresh()
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    -- RecordingLeave 触发时 reg_recording() 尚未清空，延迟刷新才能让指示器消失
    vim.defer_fn(function()
      require("lualine").refresh()
    end, 50)
  end,
})
lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

-- ── LSP ──────────────────────────────────────────────────────────────────
-- lvim 为「mason-lspconfig 支持且不在 skipped_servers」的 server 生成 ftplugin
-- 模板（~/.local/share/lunarvim/site/after/ftplugin/）实现自动配置。模板是
-- 缓存：改动 skipped_servers 后需删除该目录重启（或 :LvimCacheReset）重新
-- 生成；该目录空置会令自动配置整体失效（守卫缺陷，修复见
-- https://github.com/LunarVim/LunarVim/pull/4667）。
-- Python 走自动配置的 pyright + ruff：pyright 管补全/跳转/hover，ruff 管
-- lint/格式化（ruff 无语言智能，不可单用）。
-- 显式 setup 仅用于两类：denols/eslint/cssmodules_ls/unocss 在 lvim 内置
-- skipped_servers 里（竞争服务器需用户自选）；tsserver/volar 需自定义
-- root_dir / hybridMode。manager 对已显式配置的 server 不会重复挂载。

local util = require "lspconfig/util"
require("lspconfig")['denols'].setup({
  on_attach = require("lvim.lsp").common_on_attach,
  root_dir = util.root_pattern("deno.json", "deno.jsonc"),
  suggest = {
    imports = {
      hosts = {
        ["https://deno.land"] = true
      }
    }
  }
})

require("lspconfig")['tsserver'].setup({
  on_attach = require("lvim.lsp").common_on_attach,
  root_dir = util.root_pattern("tsconfig.json"),
  single_file_support = false
})
require("lspconfig")['cssmodules_ls'].setup({
  -- optionally
  filetypes = { "typescriptreact", "javascriptreact" },
  init_options = {
    camelCase = false,
  },
})

local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'
configs.solidity = {
  default_config = {
    cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
    filetypes = { 'solidity' },
    root_dir = lspconfig.util.find_git_ancestor,
    single_file_support = true,
  },
}

require("lspconfig")['unocss'].setup({
  filetypes = { 'vue' },
  root_dir = util.root_pattern("uno.config.ts")
})
require("lspconfig")["eslint"].setup({
  root_dir = util.root_pattern("eslint.config.mts", "eslint.config.js", "eslint.config.cjs")
})

require("lspconfig")['volar'].setup({
  init_options = {
    vue = {
      hybridMode = false,
    },
  },
})

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  -- { command = 'eslint',       filetypes = { "vue" } },
  { command = 'prettier',          filetypes = { "vue" } },
  { command = 'goimports',         filetypes = { "go" } },
  { command = 'gofmt',             filetypes = { "go" } },
  { command = 'gofumpt',           filetypes = { "go" } },
  { command = 'goimports_reviser', filetypes = { "go" } },
  { command = 'golines',           filetypes = { "go" } },
  -- { command = 'markdownlint',      filetypes = { "markdown" } },
}

lvim.plugins = require("plugins.init")
