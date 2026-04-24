-- Main Neovim entrypoint for this configuration.
-- General use:
-- - Set global providers and core editor options.
-- - Bootstrap the lazy.nvim plugin loader.
-- - Pull in the thin config modules that configure tools around the plugin specs.

-- Leader keys and language provider configuration are set before plugin loading.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.node_host_prog = "/usr/lib/node_modules/neovim/bin/cli.js"
vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

package.path = package.path .. ";/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua"
package.cpath = package.cpath .. ";/usr/lib/lua/5.1/?.so;/usr/lib/lua/5.1/?/core.so"

-- Keep the baseline UI small here and let plugins handle the heavier presentation layer.
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Load the plugin manager before the rest of the module tree.
require("config.lazy")

-- Tool-specific config modules. LSP wiring currently lives in the plugin spec
-- itself, so config.lsp is left present but disabled here.
require("config.mason")
-- require("config.lsp")
require("config.conform")
require("config.lint")
require("config.dap")
require("config.snippets")
