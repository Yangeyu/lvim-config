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

lvim.plugins = {
  { 'catppuccin/nvim' },
  { 'ayu-theme/ayu-vim' },
  { 'EdenEast/nightfox.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'rose-pine/neovim' },
  { 'nyoom-engineering/oxocarbon.nvim' },
  { 'ellisonleao/gruvbox.nvim' },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        keymap("n", "<Esc>", ":Noice dismiss<CR>", opts)
      })
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  -- nvim-yati 是 Treesitter 驱动的智能缩进插件，在 JSX / TSX 文件中缩进最自然。
  {
    "yioneko/nvim-yati",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        yati = { enable = true, default_lazy = true },
        indent = { enable = false } -- 关闭默认 indent，使用 yati
      })
    end
  },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   event = "InsertEnter",
  --   dependencies = { "zbirenbaum/copilot.lua" },
  --   config = function()
  --     -- vim.defer_fn(function()
  --     require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
  --     require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
  --     -- end, 100)
  --   end,
  -- },
  {
    "Exafunction/windsurf.vim",
    config = function()
      -- Change '<C-g>' here to any keycode you like.
      -- vim.g.codeium_manual = true
      vim.g.codeium_disable_bindings = 1
      vim.keymap.set('i', ';;', function() return vim.fn['codeium#Accept']() end, { expr = true })
      vim.keymap.set('i', ';,', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
      -- vim.keymap.set('i', ';w', function() return vim.fn['codeium#AcceptNextWord']() end, { expr = true })
      vim.keymap.set('i', ';l', function() return vim.fn['codeium#AcceptNextLine']() end, { expr = true })
      -- vim.keymap.set('i', ';,', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
    end
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
  -- {
  --   "luochen1990/rainbow",
  --   config = function()
  --     vim.g.rainbow_active = 1
  --   end
  -- },
  {
    'phaazon/hop.nvim',
    event = "BufRead",
    config = function()
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
      keymap("n", "<space>j", ":HopLineStartAC<CR>", opts)
      keymap("n", "<space>k", ":HopLineStartBC<CR>", opts)
      keymap("n", "<space>r", ":HopChar1<CR>", opts)
    end
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end
  },
  {
    "tpope/vim-surround",

    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    init = function()
      vim.o.timeoutlen = 500
    end
  },
  -- {
  --   "andymass/vim-matchup",
  --   event = "CursorMoved",
  --   config = function()
  --     vim.g.matchup_matchparen_offscreen = { method = "popup" }
  --   end,
  -- },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  {
    "nvim-telescope/telescope-project.nvim",
    event = "BufWinEnter",
  },
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "gcmt/wildfire.vim",
    init = function()
      vim.g.wildfire_objects = { "i'", 'i"', "i)", "i]", "i}", "ip", "it", "i>", "iw", "i`" }
      -- vim.api.nvim_set_keymap("n", "<space>nn", "<Plug>(wildfire-fuel)", { noremap = true, silent = true })
    end
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    config = function()
      require("telescope").load_extension("live_grep_args")
      -- keymap("n", "<space>sa", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts)
      keymap("n", "<space>sa", ":Telescope live_grep_args theme=ivy<CR>", opts)
      keymap("n", "<space>F", ":Telescope current_buffer_fuzzy_find theme=ivy<CR>", opts)
    end
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "javascript", "typescript", "vue" }, {
        RGB = true,      -- #RGB hex codes
        RRGGBB = true,   -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true,   -- CSS rgb() and rgba() functions
        hsl_fn = true,   -- CSS hsl() and hsla() functions
        css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
        opts = {
          window = {
            width = 0.75, -- 百分比 or 固定宽度
            options = {
              number = false,
              relativenumber = false,
              signcolumn = "no",
              foldcolumn = "0",
            },
          },
          plugins = {
            tmux = { enabled = false },
          },
        },
      }

      lvim.builtin.which_key.mappings["z"] = { "<cmd>ZenMode<cr>", "zen mode" }
    end
  },
  -- 恢复工作区
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  -- 退出文件在进入时，回到当时编辑位置
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },
  -- mark 做标记
  {
    "chentoast/marks.nvim",
    config = function()
      require "marks".setup({
        force_write_shada = true,
        refresh_interval = 250,
        mappings = {
          set_next = "m,",
          next = "mn",
          preview = false, -- pass false to disable only this default mapping
          set_bookmark0 = "m0",
          prev = "mp"
        }
      })
      -- vim.api.nvim_set_keymap("n", "dm<space>", ":delmarks!<CR>", { noremap = true, silent = true })
    end
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,          -- Hide cursor while scrolling
        stop_eof = true,             -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil,       -- Default easing function
        pre_hook = nil,              -- Function to run before the scrolling animation starts
        post_hook = nil,             -- Function to run after the scrolling animation ends
      })
    end
  },
  {
    "junegunn/vim-easy-align",
  },
  {
    'voldikss/vim-translator',
    config = function()
      -- vim.g.translator_target_lang = 'zh'
      keymap("v", "f", ":TranslateW<CR>", opts)
    end
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        prompt_library = {
          markdown = {
            dirs = {
              vim.fn.getcwd() .. "/.prompts",   -- Can be relative
              "~/.config/lvim/.config/prompts", -- Or absolute paths
            },
          },
        },
        adapters = {
          http = {
            my_openai = function()
              return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                  -- url = "https://openrouter.ai",
                  -- api_key = "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",
                  -- chat_url = "/api/v1/chat/completions"
                  url = "https://dashscope.aliyuncs.com",            -- optional: default value is ollama url http://127.0.0.1:11434
                  api_key = "sk-bfd20fee52af47cabef04cc13679b25e",   -- optional: if your endpoint is authenticated
                  chat_url = "/compatible-mode/v1/chat/completions", -- optional: default value, override if different
                  -- url = "https://open.bigmodel.cn/api/coding/paas/v4",
                  -- api_key = "491b525cb15443cc9e2910489f37f9d2.vxMkoEOs1PnFacdR",
                  -- chat_url = "/chat/completions"

                },
                schema = {
                  model = {
                    default = "qwen3-max"
                    -- default = "glm-4.7"
                  },
                  temperature = {
                    order = 2,
                    mapping = "parameters",
                    type = "number",
                    optional = true,
                    default = 0.8,
                    desc =
                    "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
                    validate = function(n)
                      return n >= 0 and n <= 2, "Must be between 0 and 2"
                    end,
                  },
                  max_completion_tokens = {
                    order = 3,
                    mapping = "parameters",
                    type = "integer",
                    optional = true,
                    default = nil,
                    desc = "An upper bound for the number of tokens that can be generated for a completion.",
                    validate = function(n)
                      return n > 0, "Must be greater than 0"
                    end,
                  },
                  stop = {
                    order = 4,
                    mapping = "parameters",
                    type = "string",
                    optional = true,
                    default = nil,
                    desc =
                    "Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.",
                    validate = function(s)
                      return s:len() > 0, "Cannot be an empty string"
                    end,
                  },
                  logit_bias = {
                    order = 5,
                    mapping = "parameters",
                    type = "map",
                    optional = true,
                    default = nil,
                    desc =
                    "Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.",
                    subtype_key = {
                      type = "integer",
                    },
                    subtype = {
                      type = "integer",
                      validate = function(n)
                        return n >= -100 and n <= 100, "Must be between -100 and 100"
                      end,
                    },
                  },
                }
              })
            end,
          }
        },
        -- strategies = {
        -- chat = { adapter = "my_openai", },
        -- inline = { adapter = "my_openai" },
        -- agent = { adapter = "my_openai" },
        -- },
      })
      keymap("n", "<space>C", ":CodeCompanionChat<CR>", opts)
      lvim.builtin.which_key.vmappings["c"] = {
        name = "CodeCompanion",
        c = { ":CodeCompanion adapter=my_openai add a comment block for this block in zh. And insert a blank line between the comment description and the field descriptions (@param, @returns)<cr>", "Add a comment block" },
        -- c = { ":CodeCompanion adapter=my_openai /comment<cr>", "Add a comment block" },
        a = { ":CodeCompanionAction<cr>", "Code Companion Action" },
      }
      lvim.builtin.which_key.mappings["C"] = {
        name = "CodeCompanion",
        c = { ":CodeCompanionChat<cr>", "Chat with copilot" },
        C = { ":CodeCompanionChat adapter=my_openai<cr>", "Chat with my_openai" },
      }
    end,
  },
}
