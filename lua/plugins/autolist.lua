-- =========================================================
-- AUTOLIST — Markdown list continuation and formatting
-- =========================================================
-- <Tab>, <S-Tab> and <CR> are shared with blink.cmp (completion
-- menu and snippets). blink only passes a key on to these
-- mappings when it has nothing to do itself, and it can only do
-- that for mappings that already exist when it sets up its own
-- keys in a buffer (on the first Insert mode). So these must be
-- set as soon as a Markdown buffer opens — see FileType below.

-- Buffer-local keymaps for one Markdown buffer.
local function set_keymaps(buf)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
  end

  -- Continue lists automatically.
  map("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>", "Continue Markdown list")
  map("n", "o", "o<cmd>AutolistNewBullet<cr>", "New Markdown list item")
  map("n", "O", "O<cmd>AutolistNewBulletBefore<cr>", "New Markdown list item above")

  -- Indent / dedent list items (outside a list: a normal Tab).
  map("i", "<Tab>", "<cmd>AutolistTab<cr>", "Indent Markdown list")
  map("i", "<S-Tab>", "<cmd>AutolistShiftTab<cr>", "Dedent Markdown list")

  -- Recalculate ordered lists.
  map("n", "<leader>mr", "<cmd>AutolistRecalculate<cr>", "Recalculate Markdown lists")
end

return {
  {
    "gaoDean/autolist.nvim",
    ft = { "markdown" },
    config = function()
      require("autolist").setup()

      -- The plugin is loaded BY the first Markdown buffer, so that
      -- buffer needs its keymaps now; later ones get them through
      -- the FileType autocmd. (Previously `buffer = true` here
      -- meant only the first Markdown buffer had list keymaps.)
      set_keymaps(vim.api.nvim_get_current_buf())

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          set_keymaps(event.buf)
        end,
      })
    end,
  },
}
