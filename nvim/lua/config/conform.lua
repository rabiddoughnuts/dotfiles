-- Formatter mappings for conform.nvim.
require("conform").setup({
  formatters_by_ft = {
    -- Keep the formatter map intentionally small and language-specific.
    lua = { "stylua" },
    python = { "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
  },
})
