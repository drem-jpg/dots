return {
    "tokyonight.nvim",
    opts = {
        transparent = true
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            theme = 'tokyonight',
        },
    }
}
