-- =========================================================
-- AUTOLIST — Markdown list continuation and formatting
-- =========================================================
-- <Tab>, <S-Tab> and <CR> are shared with blink.cmp (completion
-- menu and snippets). blink only passes a key on to these
-- mappings when it has nothing to do itself, and it can only do
-- that for mappings that already exist when it sets up its own
-- keys in a buffer (on the first Insert mode). So these must be
-- set as soon as a Markdown buffer opens — see FileType below.

-- True when the cursor is at the end of a list item line
-- ("- ", "* ", "+ ", "1. ", "1) "), which is when autolist would
-- indent/dedent the item.
local function at_end_of_list_item()
  local line = vim.api.nvim_get_current_line()
  local at_end = vim.api.nvim_win_get_cursor(0)[2] == #line
  return at_end and (line:match("^%s*[-+*]%s") or line:match("^%s*%d+[.)]%s")) ~= nil
end

-- Tab / Shift-Tab in Insert mode.
--
-- Not :AutolistTab / :AutolistShiftTab: outside a list item they
-- type the key with `:normal! a<Tab>`, which inserts it AFTER the
-- character under the cursor — at the start of a line the first
-- letter stays put and the rest shifts. These do the same as
-- autolist inside a list item and a plain key elsewhere.
local function tab()
  if at_end_of_list_item() then
    return "<C-t><Cmd>AutolistRecalculate<CR>" -- indent the item
  end
  return "<Tab>"
end

local function shift_tab()
  if at_end_of_list_item() then
    return "<C-d><Cmd>AutolistRecalculate<CR>" -- dedent the item
  end
  return "<C-d>" -- dedent the current line
end

-- Buffer-local keymaps for one Markdown buffer.
local function set_keymaps(buf)
  local function map(mode, lhs, rhs, desc, expr)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, expr = expr })
  end

  -- Continue lists automatically.
  map("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>", "Continue Markdown list")
  map("n", "o", "o<cmd>AutolistNewBullet<cr>", "New Markdown list item")
  map("n", "O", "O<cmd>AutolistNewBulletBefore<cr>", "New Markdown list item above")

  -- Indent / dedent list items (see tab() above).
  map("i", "<Tab>", tab, "Indent Markdown list item, or Tab", true)
  map("i", "<S-Tab>", shift_tab, "Dedent Markdown list item / line", true)

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
