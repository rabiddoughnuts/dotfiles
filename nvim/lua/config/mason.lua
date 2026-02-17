local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

mason.setup()

mason_lspconfig.setup({
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
  ensure_installed = {
    "stylua",
    "prettier",
    "eslint_d",
    "black",
    "ruff",
  },
})
