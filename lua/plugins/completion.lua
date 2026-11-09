-- =========================================================
-- COMPLETION — blink.cmp + LuaSnip
-- =========================================================
-- blink.cmp shows the completion menu; LuaSnip expands snippets.
-- The content lives in data/ and reloads without a restart:
--   data/snippets/<filetype>.lua   snippets
--   data/words.txt                 my own words/terms

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
          "words",
          "buffer",
        },

        providers = {
          -- Rank snippets above buffer words.
          snippets = {
            score_offset = 10,
          },

          -- My own words from data/words.txt (lua/custom/blink_words.lua),
          -- ranked between snippets and buffer words.
          words = {
            name = "Words",
            module = "custom.blink_words",
            score_offset = 5,
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

      -- Forget a snippet as soon as the cursor leaves it (or its
      -- text is deleted). Without this, Tab could still "jump"
      -- into an old snippet elsewhere in the buffer, moving the
      -- cursor backwards unexpectedly.
      ls.config.setup({
        region_check_events = "CursorMoved,CursorMovedI",
        delete_check_events = "TextChanged,InsertLeave",
      })

      -- ...but "leaving" still keeps the snippet in memory, parked on
      -- its end position ($0), and Shift-Tab then jumps back INTO it
      -- (e.g. back to where ;cc inserted "Claude Code", lines away).
      -- The same happens right after a snippet without stops (;cc)
      -- is expanded. LuaSnip already forgets a snippet when Tab
      -- jumps to its $0; do the same whenever the cursor lands on
      -- the $0 of a top-level snippet in any other way.
      vim.api.nvim_create_autocmd("User", {
        -- $0 is an "exit node", or an insert node when a snippet
        -- defines i(0) itself.
        pattern = { "LuasnipExitNodeEnter", "LuasnipInsertNodeEnter" },
        callback = function()
          local node = ls.session.event_node
          local is_root_end = node.pos == 0 and node.parent.parent_node == nil
          if is_root_end then
            -- After LuaSnip has finished moving to that node.
            vim.schedule(function()
              if ls.session.current_nodes[vim.api.nvim_get_current_buf()] == node then
                ls.unlink_current()
              end
            end)
          end
        end,
      })

      -- Cycle through the options of a choice node, i.e. a
      -- snippet that offers several alternatives at one spot.
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

      -- Load data/snippets/<filetype>.lua on demand and reload a
      -- file whenever it changes: on save inside Neovim (autocmd)
      -- or from any other editor (libuv file watcher).
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { require("custom.datafile").path("snippets") },
        fs_event_providers = { autocmd = true, libuv = true },
      })
    end,
  },
}
