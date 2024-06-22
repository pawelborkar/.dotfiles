-- lvim configurations
-- Custom Keybindings
lvim.keys.insert_mode["ii"] = "<Esc>"
lvim.keys.insert_mode["im"] = "<Esc>"
lvim.keys.normal_mode["<S-Tab>"] = ":bnext<CR>"
lvim.keys.normal_mode["<leader>n"] = ":bnext<CR>"
lvim.keys.normal_mode["<S-R>"] = ":FlutterReload<CR>"

vim.api.nvim_set_keymap("n", "<C-q>", ":qa!<cr>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-q>", "<Esc>:qa!<cr>", { noremap = true })
vim.opt.relativenumber = true

-- Additional Plugins
lvim.plugins = {
  { "maxmx03/dracula.nvim" },
  { "pocco81/auto-save.nvim" },
  { "mfussenegger/nvim-dap" },
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
    args = { "--print-width", "100" },
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
