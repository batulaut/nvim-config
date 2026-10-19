-- =========================================================
-- SENTENCE SPLITTING
-- =========================================================
-- Put sentences on their own lines (handy for Markdown prose).

-- Insert a line break before the sentence under the cursor.
vim.keymap.set("n", "<leader>jk", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local cursor_pos = col + 1
  local start_pos = 1

  -- Find the beginning of the sentence under the cursor:
  -- the last ".", "!" or "?" followed by whitespace before it.
  for i = 1, math.min(cursor_pos - 1, #line) do
    if line:sub(i, i):match("[.!?]")
        and line:sub(i + 1, i + 1):match("%s") then
      start_pos = i + 1

      while start_pos <= #line
          and line:sub(start_pos, start_pos):match("%s") do
        start_pos = start_pos + 1
      end
    end
  end

  -- Nothing to split if this is the first sentence.
  if start_pos == 1 then
    return
  end

  local before = line:sub(1, start_pos - 1):gsub("%s+$", "")
  local after = line:sub(start_pos)

  local row = vim.api.nvim_win_get_cursor(0)[1]

  vim.api.nvim_buf_set_lines(
    0,
    row - 1,
    row,
    false,
    { before, after }
  )

  -- Keep the cursor at approximately the same position.
  vim.api.nvim_win_set_cursor(0, {
    row + 1,
    math.max(0, col - start_pos + 1),
  })
end, { desc = "Split before current sentence" })

-- Break the current line after every ". " (only periods,
-- unlike <leader>jk which also handles "!" and "?").
vim.keymap.set("n", "<leader>jj", function()
  vim.cmd([[s/\.\s\+/.\r/g]])
end, { desc = "Split all sentences into lines" })
