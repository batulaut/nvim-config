-- =========================================================
-- SENTENCE SPLITTING
-- =========================================================
-- Put sentences on their own lines (handy for Markdown prose).
--   <leader>jj  split every sentence on the current line
--   <leader>jk  split only before the sentence under the cursor
--
-- A sentence ends with ".", "!" or "?" followed by a space
-- (details in lua/custom/markdown_text.lua). Inside a list item
-- or blockquote, the new lines stay part of it:
--   "- Satu. Dua?"  →  "- Satu."
--                      "  Dua?"
-- Headings and fenced code blocks are left alone.

local md = require("custom.markdown_text")

-- Split `line` at the given breaks. Returns the new lines.
local function split_line(line, breaks)
  local continuation = md.continuation(md.prefix(line))
  local lines, from = {}, 1

  for _, b in ipairs(breaks) do
    lines[#lines + 1] = line:sub(from, b.stop)
    from = b.start
  end
  lines[#lines + 1] = line:sub(from)

  for i = 2, #lines do
    lines[i] = continuation .. lines[i]
  end
  return lines
end

-- Breaks on the current line, or nil when this line should not
-- be split (heading, code block, or a single sentence).
local function current_breaks(row, line)
  if md.code_block_rows(row, row)[row] or md.prefix(line):match("#") then
    return nil
  end
  local breaks = md.sentence_breaks(line)
  return #breaks > 0 and breaks or nil
end

vim.keymap.set("n", "<leader>jj", function()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local breaks = current_breaks(row, line)
  if not breaks then
    return
  end

  vim.api.nvim_buf_set_lines(0, row - 1, row, false, split_line(line, breaks))
end, { desc = "Split all sentences into lines" })

vim.keymap.set("n", "<leader>jk", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local breaks = current_breaks(row, line)
  if not breaks then
    return
  end

  -- The last sentence start at or before the cursor (col is
  -- 0-based, break positions are 1-based).
  local chosen
  for _, b in ipairs(breaks) do
    if b.start <= col + 1 then
      chosen = b
    end
  end
  if not chosen then
    return -- cursor is in the first sentence
  end

  local new_lines = split_line(line, { chosen })
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, new_lines)

  -- Keep the cursor on the same character.
  local shift = chosen.start - 1 - #md.continuation(md.prefix(line))
  vim.api.nvim_win_set_cursor(0, { row + 1, math.max(0, col - shift) })
end, { desc = "Split before current sentence" })
