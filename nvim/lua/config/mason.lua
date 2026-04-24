-- Configure Mason and the language servers/tools this setup expects to manage.
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

mason.setup()

mason_lspconfig.setup({
  -- Language servers installed and kept available for the main languages in this config.
  ensure_installed = {
    "clangd",
    "html",
    "jdtls",
    "lua_ls",
    "ruby_lsp",
    "pyright",
    "rust_analyzer",
    "eslint",
    "ts_ls",
  },
})

mason_tool_installer.setup({
  -- Non-LSP formatter/linter tools used by conform.nvim and nvim-lint.
  ensure_installed = {
    "stylua",
    "prettier",
    "eslint_d",
    "black",
    "ruff",
  },
})
