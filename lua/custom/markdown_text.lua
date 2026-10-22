-- =========================================================
-- MARKDOWN TEXT
-- =========================================================
-- Helper module (no side effects): how a Markdown line is built.
-- Shared by lua/custom/sentences.lua and lua/custom/capitalize.lua
-- so both agree on what a "sentence" and a "list prefix" are.

local M = {}

-- The structural start of a line, before the actual text:
-- indentation, blockquote markers ("> > "), and one of
-- heading ("## "), task item ("- [ ] "), bullet ("- ", "* ",
-- "+ ") or ordered item ("1. ", "2) ").
function M.prefix(line)
  local prefix, rest = "", line

  while true do
    local quote = rest:match("^%s*>%s?")
    if not quote then
      break
    end
    prefix, rest = prefix .. quote, rest:sub(#quote + 1)
  end

  local marker = rest:match("^%s*#+%s+")
    or rest:match("^%s*[-+*]%s+%[[ xX]%]%s+")
    or rest:match("^%s*[-+*]%s+")
    or rest:match("^%s*%d+[.)]%s+")
    or rest:match("^%s*")

  return prefix .. marker
end

-- What a continuation line of the same block starts with, so a
-- sentence moved to its own line stays inside the list item /
-- blockquote: quote markers are repeated, everything else
-- becomes spaces of the same width.
function M.continuation(prefix)
  local quotes = prefix:match("^[%s>]*>%s?") or ""
  return quotes .. string.rep(" ", #prefix - #quotes)
end

-- Byte ranges { from, to } of inline code spans (`code`).
function M.code_spans(line)
  local spans, pos = {}, 1
  while true do
    local open_from, open_to = line:find("`+", pos)
    if not open_from then
      break
    end
    local ticks = line:sub(open_from, open_to)
    local close_from, close_to = line:find(ticks, open_to + 1, true)
    if not close_from then
      break
    end
    spans[#spans + 1] = { open_from, close_to }
    pos = close_to + 1
  end
  return spans
end

local function inside(spans, index)
  for _, span in ipairs(spans) do
    if index >= span[1] and index <= span[2] then
      return true
    end
  end
  return false
end

-- Places where one sentence ends and the next begins, as a list
-- of { stop = last byte of the sentence, start = first byte of
-- the next one }. A sentence ends with ".", "!" or "?" (also
-- "?!" or "..."), optionally followed by closing characters
-- such as ) " ' * _, and then whitespace. Ignored: the list
-- prefix ("1. " is not a sentence) and inline code.
--
-- Abbreviations ("mis. ", "e.g. ") look like sentence ends;
-- there is no reliable way to tell them apart.
function M.sentence_breaks(line)
  local breaks = {}
  local spans = M.code_spans(line)
  local pos = #M.prefix(line) + 1

  while true do
    local from, to = line:find("[.!?]+[%)%]\"'%*_]*", pos)
    if not from then
      break
    end
    local next_start = line:find("%S", to + 1)
    if line:sub(to + 1, to + 1):match("%s") and next_start and not inside(spans, from) then
      breaks[#breaks + 1] = { stop = to, start = next_start }
    end
    pos = to + 1
  end

  return breaks
end

-- Rows (1-based, first..last) that are inside a fenced code
-- block (``` or ~~~), fence lines included, as a set.
function M.code_block_rows(first, last)
  local rows, in_block = {}, false
  local lines = vim.api.nvim_buf_get_lines(0, 0, last, false)
  for row, line in ipairs(lines) do
    local is_fence = line:match("^%s*```") or line:match("^%s*~~~")
    if is_fence or in_block then
      if row >= first then
        rows[row] = true
      end
    end
    if is_fence then
      in_block = not in_block
    end
  end
  return rows
end

return M
