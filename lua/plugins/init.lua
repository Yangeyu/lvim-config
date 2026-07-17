local opts   = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

return {

  -- 图片预览：自研插件，用 iTerm2 原生图片协议渲染，规避 Kitty 协议残留
  -- 和 ueberzugpp 乱码问题（详见插件 README）
  -- 本地开发时可临时换成 dir = "~/Workplace/vim-plugins/iterm-image.nvim"
  {
    "Yangeyu/iterm-image.nvim",
    config = function()
      require("iterm-image").setup()
    end,
  },

  -- 编辑 Neovim Lua 项目时自动注入 vim 运行时类型库，
  -- lua_ls 不再报 Undefined global `vim`，且 vim.* API 有补全
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- 出现 vim.uv 字样时加载 libuv 类型定义
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  { 'catppuccin/nvim' },
  { 'ayu-theme/ayu-vim' },
  { 'EdenEast/nightfox.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'rose-pine/neovim' },
  { 'nyoom-engineering/oxocarbon.nvim' },
  { 'ellisonleao/gruvbox.nvim' },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.8,                      -- 0.6      [0, 1]
      trailing_stiffness = 0.6,             -- 0.45     [0, 1]
      stiffness_insert_mode = 0.7,          -- 0.5      [0, 1]
      trailing_stiffness_insert_mode = 0.7, -- 0.5      [0, 1]
      damping = 0.95,                       -- 0.85     [0, 1]
      damping_insert_mode = 0.95,           -- 0.9      [0, 1]
      distance_stop_animating = 0.5,        -- 0.1      > 0
      hide_target_hack = true,
      never_draw_over_target = true,
    },
  },
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
        views = {
          cmdline_popup = {
            -- position = { row = 5, col = "50%", },
            -- size = { width = 120, height = "auto", },
          },
        },
      })
      keymap("n", "<Esc>", ":Noice dismiss<CR>", opts)
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
    'Yangeyu/hop.nvim',
    event = "BufRead",
    config = function()
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
      keymap("n", "<space>j", ":HopLineStartAC<CR>", opts)
      keymap("n", "<space>k", ":HopLineStartBC<CR>", opts)
      keymap("n", "f", ":HopChar1<CR>", opts)
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
      keymap("n", "F", ":Telescope current_buffer_fuzzy_find theme=ivy<CR>", opts)
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
  -- :JsonExpand — 把 JSON 里转义存放的 JSON 字符串就地展开并美化
  -- （数据库 text 列导出的 "{\"a\":1}" 形态）。标量字符串不动，jq 失败 buffer 不动。
  {
    "Yangeyu/json-expand.nvim",
    cmd = "JsonExpand",
  },
  -- markdown 标题/表格/代码块等在 buffer 内直接渲染；图片由 iterm-image.nvim 负责
  -- 整行背景条一律不要（视觉统一）：code 块背景走官方开关；标题行背景的
  -- backgrounds 列表无法用空表覆盖（deep merge 会保留默认），故清空其高亮组
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      code = {
        disable_background = true,
        language_border = " ", -- 语言标签行默认用实心块 █ 填满整行
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      for i = 1, 6 do
        vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", {})
      end
    end,
  },
}
