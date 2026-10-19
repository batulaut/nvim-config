-- =========================================================
-- COMPLETION — blink.cmp + LuaSnip
-- =========================================================
-- blink.cmp shows the completion menu; LuaSnip expands snippets.
-- Snippet content itself lives in lua/snippets/.

return {
  -- -------------------------------------------------------
  -- blink.cmp — Completion menu
  -- -------------------------------------------------------

  {
    "saghen/blink.cmp",

    dependencies = {
      "saghen/blink.lib",
      "L3MON4D3/LuaSnip",
    },

    build = function()
      require("blink.cmp").build():pwait()
    end,

    opts = {
      -- Tab/Shift-Tab to navigate and accept; Enter also accepts.
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
      },

      completion = {
        documentation = {
          auto_show = false,
        },

        -- Nothing is selected or inserted until I choose an item.
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
      },

      -- For now, use the Lua fuzzy matcher instead of the native
      -- Rust matcher.
      fuzzy = {
        implementation = "lua",

        sorts = {
          "exact",
          "score",
          "sort_text",
        },
      },

      sources = {
        default = {
          "snippets",
          "buffer",
        },

        providers = {
          -- Rank snippets above buffer words.
          snippets = {
            score_offset = 10,
          },

          -- Suggest words from all normal (file) buffers, not
          -- only the current one.
          buffer = {
            opts = {
              get_bufnrs = function()
                return vim.tbl_filter(function(bufnr)
                  return vim.bo[bufnr].buftype == ""
                end, vim.api.nvim_list_bufs())
              end,
            },
          },
        },
      },

      snippets = {
        preset = "luasnip",
      },
    },
  },


  -- -------------------------------------------------------
  -- LuaSnip — Snippet engine
  -- -------------------------------------------------------

  {
    "L3MON4D3/LuaSnip",

    config = function()
      local ls = require("luasnip")

      -- Cycle through the options of a choice node (e.g. ;out).
      vim.keymap.set({ "i", "s" }, "<C-n>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, {
        silent = true,
        desc = "Next snippet choice",
      })

      vim.keymap.set({ "i", "s" }, "<C-p>", function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end, {
        silent = true,
        desc = "Previous snippet choice",
      })

      -- My snippets.
      require("snippets.prompts")
    end,
  },
}
