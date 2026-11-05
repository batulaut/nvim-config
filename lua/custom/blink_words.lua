-- =========================================================
-- BLINK SOURCE — My Words
-- =========================================================
-- Completion source for blink.cmp that offers the entries of
-- data/words.txt. Registered in lua/plugins/completion.lua.
--
-- The file is re-read only when it has changed (mtime check),
-- so edits apply on the next completion without a restart.

local datafile = require("custom.datafile")

local FILE = "words.txt"
local TEXT_KIND = require("blink.cmp.types").CompletionItemKind.Text

local cache = { mtime = nil, words = {} }

local function words()
  local mtime = datafile.mtime(FILE)
  if mtime ~= cache.mtime then
    cache = { mtime = mtime, words = datafile.read_lines(FILE) }
  end
  return cache.words
end

local source = {}

function source.new()
  return setmetatable({}, { __index = source })
end

function source:get_completions(ctx, callback)
  -- Replace exactly what has been typed of the keyword: from its
  -- start up to the cursor. An explicit range is needed because
  -- entries may contain spaces, which blink cannot place reliably
  -- on its own.
  --
  -- Not up to the END of the keyword (ctx.bounds is the whole
  -- word around the cursor): typing "Cla" right before "halo"
  -- and accepting "Claude Code" would then delete "halo" too.
  -- blink's own sources also stop at the cursor.
  local line = ctx.bounds.line_number - 1
  local first = ctx.bounds.start_col - 1
  local last = math.max(first, ctx.cursor[2])

  local items = {}
  for _, word in ipairs(words()) do
    items[#items + 1] = {
      label = word,
      kind = TEXT_KIND,
      textEdit = {
        newText = word,
        -- A fresh table per item: blink modifies items in place.
        range = {
          start = { line = line, character = first },
          ["end"] = { line = line, character = last },
        },
      },
    }
  end

  -- blink filters and sorts the items itself.
  callback({
    items = items,
    is_incomplete_backward = false,
    is_incomplete_forward = false,
  })
end

return source
