-- =========================================================
-- LUALINE CONFIGURATION
-- =========================================================

require("lualine").setup({
  options = {
    -- Use one statusline for the whole Neovim window.
    globalstatus = true,

    -- Keep the current mode visually obvious.
    -- Lualine changes the color/theme based on the current mode.
  },

  sections = {
    -- =====================================================
    -- LEFT SIDE
    -- =====================================================

    -- Current Vim mode.
    -- Useful while learning to stay aware of Normal/Insert/
    -- Visual/Command mode.
    lualine_a = {
      "mode",
    },

    -- File information.
    -- path = 1 → relative path from the current directory.
    lualine_b = {
      {
        "filename",
        path = 0,
      },

      -- Git branch, e.g. main, develop, feature/...
      -- This only displays Git information; it does not
      -- change or manage your Git repository.
      "branch",
    },

    -- Diagnostics from LSP/diagnostic providers.
    --
    -- Error / warning / hint information can appear here
    -- when a language server or another diagnostic source
    -- provides it.

    lualine_c = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
          hint = "󰌵 ",
        },
      },
    },

    -- =====================================================
    -- RIGHT SIDE
    -- =====================================================

    -- Search information.
    --
    -- Shows information such as the current match when
    -- searching with / or ?.
    lualine_x = {
      -- Current filetype.
      "filetype",

      -- Encoding, usually utf-8.
      -- "encoding",

      -- Line ending format: unix, dos, etc.
      -- "fileformat",
    },

    -- Current cursor position.
    --
    -- Example:
    -- 12:5 → line 12, column 5
    lualine_y = {
      -- "location",
    },

    -- Command/status information.
    --
    -- This area can show information related to the current
    -- command or operation when Lualine has something to show.
    lualine_z = {
      "progress",
    },
  },
})
