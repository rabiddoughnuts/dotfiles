return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        filetypes = {
          ["*"] = true,
        },
	      suggestion = { enabled = true },
	      panel = { enabled = true },
      })
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
  },
}