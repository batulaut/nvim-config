-- =========================================================
-- CAPITALIZE — First letter of every sentence (Markdown)
-- =========================================================
-- <leader>ca in a Markdown buffer:
--   Normal mode: every sentence on the current line.
--   Visual mode: every sentence inside the selection (v, V or
--                Ctrl-V); text outside the selection is untouched.
--
-- Capitalized: the first letter of a line's text (after list
-- markers, "- [ ] ", "> ", "#", and openers such as ( " ' * _ [)
-- and the first letter after each sentence end (". ", "! ", "? ").
-- Skipped: inline `code` and fenced code blocks.
--
-- Each line is treated as starting a sentence, which suits
-- one-sentence-per-line text (see <leader>jj). In a paragraph
-- that is hard-wrapped mid-sentence, select only what you mean.
-- Only ASCII letters are changed.

local md = require("custom.markdown_text")

-- Byte positions of the letters that start a sentence.
local function sentence_starts(line)
  local starts = {}
  local spans = md.code_spans(line)

  -- Skip openers like ( " ' * _ [ ; take the letter after them.
  local function add(from)
    local _, openers_end = line:find("^[%(%[\"'%*_]*", from)
    local letter = openers_end + 1
    if not line:sub(letter, letter):match("%a") then
      return
    end
    for _, span in ipairs(spans) do
      if letter >= span[1] and letter <= span[2] then
        return
      end
    end
    starts[#starts + 1] = letter
  end

  add(#md.prefix(line) + 1)
  for _, b in ipairs(md.sentence_breaks(line)) do
    add(b.start)
  end
  return starts
end

-- Uppercase the sentence starts of `line` that fall within
-- byte columns from..to (inclusive).
local function capitalize(line, from, to)
  for _, index in ipairs(sentence_starts(line)) do
    if index >= from and index <= to then
      line = line:sub(1, index - 1) .. line:sub(index, index):upper() .. line:sub(index + 1)
    end
  end
  return line
end

-- Capitalize rows first..last; cols(row, line) gives the byte
-- range to touch on each row.
local function capitalize_rows(first, last, cols)
  local code_rows = md.code_block_rows(first, last)
  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  local changed = false

  for i, line in ipairs(lines) do
    local row = first + i - 1
    if not code_rows[row] then
      lines[i] = capitalize(line, cols(row, line))
      changed = changed or lines[i] ~= line
    end
  end

  -- One undo step, and no "modified" flag when nothing changed.
  if changed then
    vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines)
  end
end

local function capitalize_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  capitalize_rows(row, row, function(_, line)
    return 1, #line
  end)
end

local function capitalize_selection()
  -- Read the selection while still in Visual mode ('< and '>
  -- would still point at the previous selection).
  local mode = vim.fn.mode()
  local anchor, cursor = vim.fn.getpos("v"), vim.fn.getpos(".")
  vim.cmd("normal! \27")

  local first, last = anchor[2], cursor[2]
  local first_col, last_col = anchor[3], cursor[3]
  if first > last or (first == last and first_col > last_col) then
    first, last = last, first
    first_col, last_col = last_col, first_col
  end

  capitalize_rows(first, last, function(row, line)
    if mode == "V" then
      return 1, #line
    elseif mode == "\22" then -- Ctrl-V: same columns on every row
      return math.min(anchor[3], cursor[3]), math.max(anchor[3], cursor[3])
    end
    -- v: from the start column on the first row to the end
    -- column on the last row, whole lines in between.
    return row == first and first_col or 1, row == last and last_col or #line
  end)
end

-- Mappings only in Markdown buffers.
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
