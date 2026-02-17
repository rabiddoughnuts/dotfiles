-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.node_host_prog = "/usr/lib/node_modules/neovim/bin/cli.js"
vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

package.path = package.path .. ";/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua"
package.cpath = package.cpath .. ";/usr/lib/lua/5.1/?.so;/usr/lib/lua/5.1/?/core.so"

-- Basic options (minimal example)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Load plugin manager
require("config.lazy")

-- Core configs
require("config.mason")
-- require("config.lsp")
require("config.conform")
require("config.lint")
require("config.dap")
require("config.snippets")
