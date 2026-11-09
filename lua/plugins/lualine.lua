-- =========================================================
-- LUALINE — Statusline
-- =========================================================
-- Layout:  | a | b | c          x | y | z |

return {
  {
    "nvim-lualine/lualine.nvim",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      options = {
        -- One statusline for the whole Neovim window.
        globalstatus = true,

        refresh = {
          events = {
            "WinEnter",
            "BufEnter",
            "BufWritePost",
            "SessionLoadPost",
            "FileChangedShellPost",
            "VimResized",
            "Filetype",
            "CursorMoved",
            "CursorMovedI",
            "ModeChanged",
            "TextChanged",
            "TextChangedI",
          },
        },
      },

      sections = {
        -- -------------------------------------------------
        -- Left side
        -- -------------------------------------------------

        -- Current Vim mode (also colors the statusline).
        lualine_a = {
          "mode",
        },

        lualine_b = {
          -- path = 0 → file name only
          -- (1 = relative path, 2 = absolute path).
          {
            function()
              local filepath = vim.api.nvim_buf_get_name(0)
              if filepath == "" then
                return "[No Name]"
              end

              local filename = vim.fn.fnamemodify(filepath, ":t")
              local parent = vim.fn.fnamemodify(filepath, ":h:t")

              return parent .. "/" .. filename
            end,
          },

          -- Git branch name (display only).
          "branch",
        },

        -- Errors / warnings / hints, when a language server or
        -- another diagnostic source provides them.
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

        -- -------------------------------------------------
        -- Right side
        -- -------------------------------------------------

        lualine_x = {
          "filetype",
          -- "encoding",   -- usually utf-8
          -- "fileformat", -- unix, dos, …

          -- Word count (Markdown only)
          {
            function()
              if vim.bo.filetype ~= "markdown" then
                return ""
              end

              return vim.fn.wordcount().words .. " words"
            end,
          },
        },

        lualine_y = {
          -- Current working directory
          {
            function()
              return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            end,
            icon = "󰉋",
          },
          -- "location",   -- line:column, e.g. 12:5
        },

        -- Position in the file as a percentage (Top / 42% / Bot).
        lualine_z = {
          "progress",
        },
      },
    },
  },
}
