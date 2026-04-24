-- Bootstrap and configure lazy.nvim as the plugin manager for this config.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- Clone lazy.nvim on first run so the rest of the plugin spec can load normally.
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Keep leader keys in sync before lazy loads any mappings.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Import every plugin spec from lua/plugins/.
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  -- Fall back to a built-in colorscheme during first install before the real theme loads.
  install = { colorscheme = { "habamax" } },
  -- Enable background update checks for the plugin set.
  checker = { enabled = true },
})
