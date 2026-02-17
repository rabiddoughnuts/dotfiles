# Dotfiles for CEG2410.

This will be a repository of a full setup, but as of now is just my neovim config, modules, etc.

## Neovim dotfiles
So I feel the need to say that this is something I have worked on for quite awhile, as I am not going to have a bunch of citations. My goal in these plugins was getting my neovim setup to somewhat mirror my vscode setup, so when I add things to vscode I look at if I might want or need to change anything here to copy it. Some of this was also inspired by "LazyVim". Ok, so I dont really have any sources other than googling them and finding them, but I did list them by their "sources".

    - zbirenbaum/copilot.lua - GitHub Copilot client; enabled suggestions and panel, set to attach to all filetypes.
    - zbirenbaum/copilot-cmp - Copilot completion source for nvim-cmp; initialized via require("copilot_cmp").setup() in the cmp config.
    - hrsh7th/nvim-cmp - Completion engine; configured with <C-Space> to trigger, <CR> to confirm, and Tab/Shift-Tab for selection/snippets; sources include copilot, LSP, snippets, path, buffer.
    - hrsh7th/cmp-nvim-lsp - LSP completion capabilities; used to populate default_capabilities() for all LSP servers.
    - hrsh7th/cmp-buffer - Buffer word completion source for nvim-cmp.
    - hrsh7th/cmp-path - Filesystem path completion source for nvim-cmp.
    - saadparwaiz1/cmp_luasnip - Snippet completion source for nvim-cmp (LuaSnip).
    - L3MON4D3/LuaSnip - Snippet engine; loads VSCode-style snippets on startup.
    - zbirenbaum/copilot.lua - GitHub Copilot client; enabled suggestions and panel, set to attach to all filetypes.
    - neovim/nvim-lspconfig - LSP setup; registers and enables clangd, html, jdtls, lua_ls, ruby_lsp, pyright, rust_analyzer, eslint, ts_ls with cmp capabilities.
    - williamboman/mason.nvim - Tool/LSP installer; default setup enabled.
    - williamboman/mason-lspconfig.nvim - Ensures LSP servers are installed (clangd, html, jdtls, lua_ls, ruby_lsp, pyright, rust_analyzer, eslint, ts_ls).
    - zbirenbaum/copilot.lua - GitHub Copilot client; enabled suggestions and panel, set to attach to all filetypes.
    - stevearc/conform.nvim - Formatter; uses stylua for Lua, black for Python, prettier for JS/TS.
    - zbirenbaum/copilot.lua - GitHub Copilot client; enabled suggestions and panel, set to attach to all filetypes.
    - nvim-treesitter/nvim-treesitter - Syntax trees; updates parsers via :TSUpdate.
    - nvim-neo-tree/neo-tree.nvim - File explorer; uses plenary, devicons, and nui.
    - nvim-telescope/telescope.nvim - Fuzzy finder; uses plenary.
    - folke/which-key.nvim - Keymap helper; default config.
    - zbirenbaum/copilot.lua - GitHub Copilot client; enabled suggestions and panel, set to attach to all filetypes.
    - mfussenegger/nvim-dap - Debug adapter core.
    - rcarriga/nvim-dap-ui - DAP UI; configured with default setup; depends on nvim-nio.
    - nvim-neotest/nvim-nio - Async utility required by nvim-dap-ui.
    - theHamsta/nvim-dap-virtual-text - Inline debug values; default setup.
    - windwp/nvim-autopairs - Auto-insert matching pairs; default setup.
    - kylechui/nvim-surround - Surround motions; default setup.
    - numToStr/Comment.nvim - Comment toggling; default setup with gc/gb mappings.
    - lewis6991/gitsigns.nvim - Git signs in gutter; default setup.
    - kdheepak/lazygit.nvim - LazyGit integration; command :LazyGit, depends on plenary.
    - akinsho/bufferline.nvim - Tabline/buffer UI; default setup and devicons.
    - lukas-reineke/indent-blankline.nvim - Indent guides via ibl; default setup.
    - sainnhe/gruvbox-material - Colorscheme; set to load immediately with medium background and mixed foreground.
