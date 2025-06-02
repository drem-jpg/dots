local function colorscheme()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.cmd.colorscheme "tokyonight"
end
return {
    {
        "navarasu/onedark.nvim",
        config = function()
            require('onedark').setup {
                style = 'darker',
                transparent = true
            }
        end
    },
    {
        "zenbones-theme/zenbones.nvim",
        -- Optionally install Lush. Allows for more configuration or extending the colorscheme
        -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
        -- In Vim, compat mode is turned on as Lush only works in Neovim.
        dependencies = "rktjmp/lush.nvim",
        lazy = false,
        priority = 1000,
        -- you can set set configuration options here
        -- config = function()
        --     vim.g.zenbones_darken_comments = 45
        --     vim.cmd.colorscheme('zenbones')
        -- end
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true
        },
    },
    {
        "amedoeyes/eyes.nvim",
        -- only requird if using nvim-web-devicons for icons
        -- dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "AlexvZyl/nordic.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('nordic').load()
        end,
    },
    {
        "Everblush/nvim",
        config = function()
            colorscheme()
        end
    },
    {
        "Mofiqul/dracula.nvim",
        lazy = false,
        config = function()
        end
    },
    {
        "rebelot/kanagawa.nvim",
        config = function()
            colorscheme()
        end
    },
    {
        "craftzdog/solarized-osaka.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            theme = 'tokyonight',
        },
    },
}
