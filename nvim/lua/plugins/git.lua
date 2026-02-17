return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}