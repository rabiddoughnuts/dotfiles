-- Linter mappings and lint-on-save behavior for nvim-lint.
local lint = require("lint")

lint.linters_by_ft = {
  python = { "ruff" },
  javascript = { "eslint_d" },
}

-- Run lint after writes so diagnostics stay current without manual commands.
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    lint.try_lint()
  end,
})
