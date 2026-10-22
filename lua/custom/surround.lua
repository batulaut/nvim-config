-- =========================================================
-- SURROUND — Wrap the Visual selection (Markdown)
-- =========================================================
-- In a Markdown buffer: select text, press <leader>su, then the
-- character to wrap it with:
--   ( ) [ ] { } < >   brackets (either side gives the pair)
--   " ' `             quotes / inline code
--   *                 **bold**
--   _                 _italic_
--   ~                 ~~strikethrough~~
-- Esc cancels. v wraps exactly the selection; V wraps whole
-- lines (the first and last line). Ctrl-V is not supported.

local delimiters = {
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
  ["_"] = { "_", "_" },
  ["~"] = { "~~", "~~" },
}

local function surround_selection()
  -- Read the selection while still in Visual mode.
  local mode = vim.fn.mode()
  local anchor, cursor = vim.fn.getpos("v"), vim.fn.getpos(".")
  vim.cmd("normal! \27")

  if mode == "\22" then
    vim.notify("Surround: Ctrl-V (block) selection is not supported", vim.log.levels.WARN)
    return
  end

  local start_row, start_col = anchor[2], anchor[3]
  local end_row, end_col = cursor[2], cursor[3]
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  vim.api.nvim_echo({ { "Surround with: " } }, false, {})
  local char = vim.fn.getcharstr()
  vim.api.nvim_echo({ { "" } }, false, {})
  if char == "\27" then
    return
  end

  local pair = delimiters[char]
  if not pair then
    vim.notify("Surround: unsupported character " .. vim.inspect(char), vim.log.levels.WARN)
    return
  end
  local open, close = pair[1], pair[2]

  if mode == "V" then
    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
    lines[1] = open .. lines[1]
    lines[#lines] = lines[#lines] .. close
    vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, lines)
    return
  end

  -- v: byte columns are 1-based and point at the START of the
  -- last selected character, which may be several bytes long
  -- ("—", "é") or past the line end (v$). Find the byte just
  -- after it, within the line.
  local last_line = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, false)[1]
  local end_byte = math.min(end_col, #last_line)
  if end_byte > 0 then
    end_byte = end_byte + vim.str_utf_end(last_line, end_byte)
  end
  local start_byte = math.min(start_col, #vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, false)[1] + 1)

  -- Insert the closing text first so the start position stays valid.
  vim.api.nvim_buf_set_text(0, end_row - 1, end_byte, end_row - 1, end_byte, { close })
  vim.api.nvim_buf_set_text(0, start_row - 1, start_byte - 1, start_row - 1, start_byte - 1, { open })
end

-- Mapping only in Markdown buffers.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    vim.keymap.set("x", "<leader>su", surround_selection, {
      buffer = event.buf,
      desc = "Surround selection",
    })
  end,
})
