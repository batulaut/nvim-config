-- =========================================================
-- CAPITALIZE — Sentence capitalization for Markdown
-- =========================================================

local function capitalize_line(line)
  -- Capitalize the first letter after common Markdown prefixes.
  local prefixes = {
    "^(%s*#+%s+)(%a)",
    "^(%s*>%s*)(%a)",
    "^(%s*[-+*]%s+)(%a)",
    "^(%s*%d+[.)]%s+)(%a)",
    "^(%s+)(%a)",
  }

  for _, pattern in ipairs(prefixes) do
    line = line:gsub(pattern, function(prefix, letter)
      return prefix .. letter:upper()
    end, 1)
  end

  -- Capitalize the first letter of a plain line.
  line = line:gsub("^(%s*)(%a)", function(prefix, letter)
    return prefix .. letter:upper()
  end, 1)

  -- Capitalize after sentence-ending punctuation and whitespace.
  line = line:gsub("([.!?]%s+)(%a)", function(space, letter)
    return space .. letter:upper()
  end)

  return line
end

local function capitalize_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()

  vim.api.nvim_set_current_line(capitalize_line(line))
end

local function capitalize_selection()
  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")

  if start_pos[1] == 0 or end_pos[1] == 0 then
    return
  end

  local start_row, start_col = start_pos[1], start_pos[2] - 1
  local end_row, end_col = end_pos[1], end_pos[2]

  -- Normalize selection direction.
  if start_row > end_row
      or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  local lines = vim.api.nvim_buf_get_text(
    0,
    start_row - 1,
    start_col,
    end_row - 1,
    end_col,
    {}
  )

  for i, line in ipairs(lines) do
    lines[i] = capitalize_line(line)
  end

  vim.api.nvim_buf_set_text(
    0,
    start_row - 1,
    start_col,
    end_row - 1,
    end_col,
    lines
  )
end

-- Define mappings only for Markdown buffers.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    vim.keymap.set("n", "<leader>ca", capitalize_current_line, {
      buffer = event.buf,
      desc = "Capitalize sentences on current line",
    })

    vim.keymap.set("x", "<leader>ca", capitalize_selection, {
      buffer = event.buf,
      desc = "Capitalize selected sentences",
    })
  end,
})
