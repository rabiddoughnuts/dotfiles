-- Git integration plugins for inline signs and LazyGit access.
return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    -- Load LazyGit only when its command is invoked.
    cmd = "LazyGit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
