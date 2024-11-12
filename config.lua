-- lvim configurations
-- Custom Keybindings
lvim.keys.insert_mode["ij"] = "<Esc>"
lvim.keys.normal_mode["<S-Tab>"] = ":bnext<CR>"
lvim.keys.normal_mode["<leader>n"] = ":bnext<CR>"
lvim.keys.normal_mode["<leader>y"] = ":normal! ggVG\"+y<CR>"
lvim.keys.normal_mode["<S-R>"] = ":FlutterReload<CR>"

-- Ensure `p` pastes from the clipboard register
lvim.keys.normal_mode["p"] = "\"+p"
lvim.builtin.which_key.setup.plugins.presets.z = true

vim.api.nvim_set_keymap("n", "<C-q>", ":qa!<cr>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-q>", "<Esc>:qa!<cr>", { noremap = true })
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Additional Plugins
lvim.plugins = {
  { "catppuccin/nvim" },
  { "maxmx03/dracula.nvim" },
  { "pocco81/auto-save.nvim" },
  { "mfussenegger/nvim-dap" },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",
    },
    opts = {
      ---@type string
      arg = "leetcode.nvim",

      ---@type lc.lang
      lang = "python3",

      cn = { -- leetcode.cn
        enabled = false, ---@type boolean
        translator = true, ---@type boolean
        translate_problems = true, ---@type boolean
      },

      ---@type lc.storage
      storage = {
        home = vim.fn.stdpath("data") .. "/leetcode",
        cache = vim.fn.stdpath("cache") .. "/leetcode",
      },

      ---@type table<string, boolean>
      plugins = {
        non_standalone = false,
      },

      ---@type boolean
      logging = true,

      injector = {}, ---@type table<lc.lang, lc.inject>

      cache = {
        update_interval = 60 * 60 * 24 * 7, ---@type integer 7 days
      },

      console = {
        open_on_runcode = true, ---@type boolean

        dir = "row", ---@type lc.direction

        size = { ---@type lc.size
          width = "90%",
          height = "75%",
        },

        result = {
          size = "60%", ---@type lc.size
        },

        testcase = {
          virt_text = true, ---@type boolean

          size = "40%", ---@type lc.size
        },
      },

      description = {
        position = "left", ---@type lc.position

        width = "40%", ---@type lc.size

        show_stats = true, ---@type boolean
      },

      hooks = {
        ---@type fun()[]
        ["enter"] = {},

        ---@type fun(question: lc.ui.Question)[]
        ["question_enter"] = {},

        ---@type fun()[]
        ["leave"] = {},
      },

      keys = {
        toggle = { "q" }, ---@type string|string[]
        confirm = { "<CR>" }, ---@type string|string[]

        reset_testcases = "r", ---@type string
        use_testcase = "U", ---@type string
        focus_testcases = "H", ---@type string
        focus_result = "L", ---@type string
      },

      ---@type lc.highlights
      theme = {},

      ---@type boolean
      image_support = false,
    },
  },
  {
    "akinsho/flutter-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
    config = function()
      require('flutter-tools').setup {
        -- (uncomment below line for windows only)
        -- flutter_path = "home/flutter/bin/flutter.bat",

        debugger = {
          -- make these two params true to enable debug mode
          enabled = false,
          run_via_dap = false,
          register_configurations = function(_)
            require("dap").adapters.dart = {
              type = "executable",
              command = vim.fn.stdpath("data") .. "/mason/bin/dart-debug-adapter",
              args = { "flutter" }
            }

            require("dap").configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch flutter",
                dartSdkPath = '/usr/bin/flutter/bin/cache/dart-sdk/',
                flutterSdkPath = "/usr/bin/flutter",
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
              }
            }
            -- uncomment below line if you've launch.json file already in your vscode setup
            -- require("dap.ext.vscode").load_launchjs()
          end,
        },
        dev_log = {
          -- toggle it when you run without DAP
          enabled = false,
          open_cmd = "tabedit",
        },
        lsp = {
          on_attach = require("lvim.lsp").common_on_attach,
          capabilities = require("lvim.lsp").default_capabilities,
        },

      }
    end
  },
  -- for dart syntax hightling
  {
    "dart-lang/dart-vim-plugin"
  },
}

-- Floating Terminal Commands
lvim.builtin.which_key.mappings["t"] = {
  name = "+Terminal",
  f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
  v = { "<cmd>2ToggleTerm size=30 direction=vertical<cr>", "Split vertical" },
  h = { "<cmd>2ToggleTerm size=30 direction=horizontal<cr>", "Split horizontal" },
}

-- Formatters
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "black" },
  {
    name = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespace
    -- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
    args = { "--line-width", "150" },
    ---@usage only start in these filetypes, by default it will attach to all filetypes it supports
    filetypes = { "javascript", "jsx", "javascriptreact", "typescript", "tsx", "typescriptreact" },
  },
}

lvim.format_on_save.enabled = true

-- Linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { name = "flake8" },
}

lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "pyright"
end, lvim.lsp.automatic_configuration.skipped_servers)

local opts = {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace"
      }
    }
  }
}
require("lvim.lsp.manager").setup("pyright", opts)

-- Code actions
local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    name = "proselint",
  },
}

-- Colorscheme
lvim.colorscheme = "dracula"
lvim.transparent_window = true
