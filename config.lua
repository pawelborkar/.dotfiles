-- =====================================================
-- LunarVim Configuration
-- =====================================================

-- UI and Visual Settings
lvim.colorscheme = "dracula"
lvim.transparent_window = true

-- Editor Behavior
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Format on Save
lvim.format_on_save = {
  enabled = true,
  pattern = { "*.py", "*.js", "*.jsx", "*.ts", "*.tsx", "*.go" },
  timeout = 1000,
}

-- Disable problematic builtin features
lvim.builtin.indentlines.active = false

-- =====================================================
-- TREESITTER CONFIGURATION
-- =====================================================

lvim.builtin.treesitter.ensure_installed = {
  "python",
  "javascript",
  "typescript",
  "go",
  "gomod",
  "gowork",
  "gosum",
}

-- =====================================================
-- KEYBINDINGS
-- =====================================================

-- Insert Mode
lvim.keys.insert_mode["ij"] = "<Esc>"

-- Normal Mode
lvim.keys.normal_mode["<S-Tab>"] = ":bnext<CR>"
lvim.keys.normal_mode["<leader>n"] = ":bnext<CR>"
lvim.keys.normal_mode["<leader>y"] = ":normal! ggVG\"+y<CR>"
lvim.keys.normal_mode["<S-R>"] = ":FlutterReload<CR>"
lvim.keys.normal_mode["p"] = "\"+p" -- Paste from clipboard
lvim.keys.normal_mode["|"] = ":vsplit<CR>"
lvim.keys.normal_mode["-"] = ":split<CR>"

-- Quick Quit
vim.api.nvim_set_keymap("n", "<C-q>", ":qa!<cr>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-q>", "<Esc>:qa!<cr>", { noremap = true })

-- =====================================================
-- WHICH-KEY CONFIGURATION
-- =====================================================

lvim.builtin.which_key.setup.plugins.presets.z = true

lvim.builtin.which_key.mappings["t"] = {
  name = "+Terminal",
  f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
  v = { "<cmd>2ToggleTerm size=30 direction=vertical<cr>", "Split vertical" },
  h = { "<cmd>2ToggleTerm size=30 direction=horizontal<cr>", "Split horizontal" },
}

-- =====================================================
-- DIAGNOSTICS CONFIGURATION
-- =====================================================

vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    prefix = "●",
    format = function(diagnostic)
      local message = diagnostic.message
      if #message > 80 then
        return message:sub(1, 77) .. "..."
      end
      return message
    end,
  },
  float = {
    border = "rounded",
    wrap = true,
    source = "always",
  },
})

-- =====================================================
-- LSP CONFIGURATION
-- =====================================================

-- Ensure LSP servers are installed
lvim.lsp.installer.setup.ensure_installed = {
  "pyright",
  "gopls",
}

-- Python path detection function
local function get_python_path(workspace)
  local util = require("lspconfig/util")

  -- 1. Use active virtualenv
  if vim.env.VIRTUAL_ENV then
    return util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- 2. Look for virtualenv in workspace
  local venv_names = { ".venv", "venv", "env" }
  for _, name in ipairs(venv_names) do
    local path = util.path.join(workspace, name, "bin", "python")
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  -- 3. Fallback to system python
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

-- Pyright LSP setup
local lspconfig = require("lspconfig")
lspconfig.pyright.setup({
  on_init = function(client)
    local root = client.config.root_dir
    client.config.settings.python.pythonPath = get_python_path(root)
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})

-- Skip automatic configuration for pyright (we handle it manually above)
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "pyright"
end, lvim.lsp.automatic_configuration.skipped_servers)

-- Additional pyright setup via LunarVim manager
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

-- =====================================================
-- FORMATTERS, LINTERS, AND CODE ACTIONS
-- =====================================================

-- Formatters
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  { name = "ruff" },
  { name = "goimports" }, -- Go formatter with auto-imports
  {
    name = "prettier",
    args = { "--line-width", "80" },
    filetypes = { "javascript", "jsx", "javascriptreact", "typescript", "tsx", "typescriptreact" },
  },
})

-- Linters
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  { name = "ruff" },
})

-- Code Actions
local code_actions = require("lvim.lsp.null-ls.code_actions")
code_actions.setup({
  { name = "proselint" },
})

-- =====================================================
-- PLUGINS
-- =====================================================

lvim.plugins = {
  -- Treesitter (pinned to stable version)
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "3d5f8e4", -- Stable commit for Neovim 0.11
    build = ":TSUpdate",
  },
  -- GitHub Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },
  -- Theme
  { "maxmx03/dracula.nvim" },
  -- Auto-save functionality
  { "pocco81/auto-save.nvim" },
  -- Debug Adapter Protocol
  { "mfussenegger/nvim-dap" },
  -- Modern indent guides (replaces the problematic indent-blankline)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = { 
          enabled = true,
          show_start = false,
          show_end = false,
        },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
      })
    end,
  },
}
