-- UI-focused plugins: tabs/buffers, indentation guides, and colorscheme.
return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({})
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Load the colorscheme eagerly so later plugins inherit the palette.
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_foreground = "mix"
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
}
