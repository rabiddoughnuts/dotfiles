-- AI assistance plugins centered on GitHub Copilot.
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        filetypes = {
          ["*"] = true,
        },
        -- Enable both inline suggestions and the larger Copilot panel UI.
        suggestion = { enabled = true },
        panel = { enabled = true },
      })
    end,
  },

  {
    -- Bridge Copilot suggestions into nvim-cmp's completion menu.
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
  },
} 
