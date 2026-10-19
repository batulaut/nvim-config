-- =========================================================
-- CATPPUCCIN — Colorscheme
-- =========================================================

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    -- Load before every other plugin so they see the final colors.
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
        transparent_background = false,

        custom_highlights = function(colors)
          return {
            -- Make window split lines easier to see.
            WinSeparator = {
              fg = colors.blue,
            },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
