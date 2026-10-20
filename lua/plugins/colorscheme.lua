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

            -- Diff colors (Diffview and :diffthis). Defined here,
            -- not in plugins/git.lua, so they survive re-running
            -- :colorscheme.
            DiffAdd = {
              bg = "#284d3a",
            },
            DiffChange = {
              bg = "#3f3b2f",
            },
            DiffText = {
              bg = "#8a6338",
              fg = "#ffe8b6",
              style = { "bold" },
            },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
