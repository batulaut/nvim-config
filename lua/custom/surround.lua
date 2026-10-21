-- =========================================================
-- SURROUND — Wrap selected Markdown text
-- =========================================================

local pairs = {
  ["("] = { "(", ")" },
  [")"] = { "(", ")" },
  ["["] = { "[", "]" },
  ["]"] = { "[", "]" },
  ["{"] = { "{", "}" },
  ["}"] = { "{", "}" },
  ["<"] = { "<", ">" },
  [">"] = { "<", ">" },
  ['"'] = { '"', '"' },
  ["'"] = { "'", "'" },
  ["`"] = { "`", "`" },
  ["*"] = { "**", "**" },
  ["~"] = { "~~", "~~" },
}

local function surround_selection()
  -- Capture the selection before requesting the delimiter.
  local anchor = vim.fn.getpos("v")
  local cursor = vim.fn.getpos(".")
  local mode = vim.fn.mode()

  local start_row, start_col = anchor[2], anchor[3] - 1
  local end_row, end_col = cursor[2], cursor[3] - 1

  -- Normalize selection direction.
  if start_row > end_row
      or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  local start_idx = start_row - 1
  local end_idx = end_row - 1

  local selected

  if mode == "V" then
    selected = vim.api.nvim_buf_get_lines(
      0, start_idx, end_idx + 1, false
    )
  else
    selected = vim.api.nvim_buf_get_text(
      0, start_idx, start_col,
      end_idx, end_col + 1, {}
    )
  end

  if #selected == 0 then
    return
  end

  local char = vim.fn.getcharstr()
  local delimiters = pairs[char]

  if not delimiters then
    vim.notify(
      "Unsupported surround character: " .. char,
      vim.log.levels.WARN
    )
    return
  end

  local open, close = delimiters[1], delimiters[2]

  selected[1] = open .. selected[1]
  selected[#selected] = selected[#selected] .. close

  if mode == "V" then
    vim.api.nvim_buf_set_lines(
      0, start_idx, end_idx + 1, false, selected
    )
  else
    vim.api.nvim_buf_set_text(
      0, start_idx, start_col,
      end_idx, end_col + 1, selected
    )
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    vim.keymap.set("x", "<leader>su", surround_selection, {
      buffer = event.buf,
      desc = "Surround Markdown selection",
    })
  end,
})
