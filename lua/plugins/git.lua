-- =========================================================
-- DIFFVIEW — Git diff & file history
-- =========================================================
-- Diff colors are set in plugins/colorscheme.lua.

return {
  {
    "sindrets/diffview.nvim",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      local hammerspoon = require("custom.hammerspoon")

      -- Equalize split widths once Diffview has drawn its layout.
      local function resize_diffview_windows()
        vim.defer_fn(function()
          vim.cmd("horizontal wincmd =")
        end, 300)
      end

      -- ---------------------------------------------------
      -- Setup
      -- ---------------------------------------------------

      require("diffview").setup({
        -- Enlarge Neovide while a diff is open, restore on close.
        hooks = {
          view_opened = function()
            hammerspoon.event("neovide-large")
            resize_diffview_windows()
          end,

          view_closed = function()
            hammerspoon.event("neovide-normal")
          end,
        },

        -- Inside a diff view: S / W jump to the next / previous
        -- change (same as ]c / [c).
        keymaps = {
          view = {
            {
              "n",
              "S",
              function()
                vim.cmd("normal! ]c")
              end,
              { desc = "Next diff change" },
            },
            {
              "n",
              "W",
              function()
                vim.cmd("normal! [c")
              end,
              { desc = "Previous diff change" },
            },
          },
        },
      })

      -- ---------------------------------------------------
      -- Keymaps
      -- ---------------------------------------------------

      local map = vim.keymap.set

      map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git diff" })
      map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Git file history" })
      map("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Git diff close" })
    end,
  },
}
