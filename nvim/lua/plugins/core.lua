return {

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local servers = {
                clangd = {},
                html = {},
                jdtls = {},
                lua_ls = {},
                ruby_lsp = {},
                pyright = {},
                rust_analyzer = {},
                eslint = {},
                ts_ls = {},
            }

            for server, config in pairs(servers) do
                config.capabilities = capabilities
                vim.lsp.config(server, config)
                vim.lsp.enable(server)
            end
        end,
    },

    { "williamboman/mason.nvim", config = true },

    { "williamboman/mason-lspconfig.nvim" },

    { "WhoIsSethDaniel/mason-tool-installer.nvim" },

    { "stevearc/conform.nvim" },

    { "mfussenegger/nvim-lint" },

    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    },

    {   "nvim-telescope/telescope.nvim", dependencies = {
            "nvim-lua/plenary.nvim"
        }   
    },

    { "folke/which-key.nvim", config = true },

    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
    },
}