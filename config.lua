-- lvim configurations
-- Additional Plugins
lvim.plugins = {
  { "maxmx03/dracula.nvim" },
  { "pocco81/auto-save.nvim" }
}

-- formatters
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

-- linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { name = "flake8" },
  {
    name = "shellcheck",
    args = { "--severity", "warning" },
  },
}

-- code actions
local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    name = "proselint",
  },
}

-- colorscheme
lvim.colorscheme = "dracula"
