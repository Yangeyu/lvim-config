-- Discord: https://discord.com/invite/Xb9B4Ny
local opts       = { noremap = true, silent = true }
local keymap     = vim.api.nvim_set_keymap
local autocmd    = vim.api.nvim_create_autocmd

lvim.colorscheme = "catppuccin-mocha"
keymap("v", "<space>a=", ":EasyAlign *=<CR>", opts)
keymap("v", "<space>a,", ":EasyAlign */,/<CR>", opts)
keymap("i", "<C-E>", "<Plug>luasnip-next-choice", opts)
keymap("i", "<C-U>", "<cmd>lua require('luasnip.extras.select_choice')()<cr>", opts)
keymap("i", "jj", "<Esc>", opts)
keymap("i", "kk", "<Esc>", opts)
keymap("i", ";a", "<Esc>la", opts)
keymap("i", ";A", "<Esc>A", opts)
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
lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

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

local vue_language_server_path =
'/Users/yang/.local/share/lvim/mason/packages/vue-language-server/node_modules/@vue/language-server'
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
require("lspconfig")["lua_ls"].setup({})
require("lspconfig")["pylsp"].setup({})
require("lspconfig")["tailwindcss"].setup({})
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
  { command = 'autopep8',          filetypes = { "python" } },
  { command = 'goimports',         filetypes = { "go" } },
  { command = 'gofmt',             filetypes = { "go" } },
  { command = 'gofumpt',           filetypes = { "go" } },
  { command = 'goimports_reviser', filetypes = { "go" } },
  { command = 'golines',           filetypes = { "go" } },
  -- { command = 'markdownlint',      filetypes = { "markdown" } },
}

lvim.plugins = require("plugins.init")
