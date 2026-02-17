local lint = require("lint")

lint.linters_by_ft = {
  python = { "ruff" },
  javascript = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    lint.try_lint()
  end,
})
