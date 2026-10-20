-- =========================================================
-- MOVE LINES (macOS / Sublime style)
-- =========================================================
-- Option + Up/Down (or Option + K/J):
--   Normal mode: move the current line.
--   Visual mode: move the selected lines as one block; the
--                selection stays active, so the keys can be
--                pressed repeatedly.
-- A count moves further. At the top/bottom of the buffer the
-- block moves as far as it can, without an error.
--
-- Examples:
--   3<A-j>           move the current line down 3 lines
--   (Visual) 2<A-k>  move the selected block up 2 lines
--
-- The moving itself is Vim's :move, which also carries marks
-- (e.g. `ma`) along with the lines and is one undo step.

-- Target for ":{first},{last}move {target}" (the block ends up
-- BELOW line {target}; 0 = top of the buffer), clamped to the
-- buffer. Returns nil when there is nowhere to move.
--
-- Note:
-- Consider using `https://github.com/nvim-mini/mini.move`
-- if you need more features in the future.

local function move_target(first, last, direction, count)
  if direction == "up" then
    if first == 1 then
      return nil
    end
    return math.max(first - count, 1) - 1
  end

  local last_line = vim.fn.line("$")
  if last == last_line then
    return nil
  end
  return math.min(last + count, last_line)
end

-- Normal mode: move the current line, keeping the cursor column.
local function move_line(direction)
  return function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local target = move_target(row, row, direction, vim.v.count1)
    if not target then
      return
    end

    vim.cmd(("move %d"):format(target))
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), col })
  end
end

-- Visual mode: move the selected lines, then select them again.
local function move_selection(direction)
  return function()
    -- Read the count first: leaving Visual mode resets it.
    local count = vim.v.count1

    -- Leave Visual mode so the '< and '> marks hold the selection.
    vim.cmd("normal! \27")

    local first, last = vim.fn.line("'<"), vim.fn.line("'>")
    local target = move_target(first, last, direction, count)
    if target then
      -- :move carries the '< and '> marks along with the lines.
      vim.cmd(("'<,'>move %d"):format(target))
    end

    -- Reselect (same mode and cursor end as before).
    vim.cmd("normal! gv")
  end
end

-- unique = true: fail loudly if something else already uses these keys.
local map = vim.keymap.set

map("n", "<A-Up>", move_line("up"), { unique = true, desc = "Move line up" })
map("n", "<A-Down>", move_line("down"), { unique = true, desc = "Move line down" })
map("n", "<A-k>", move_line("up"), { unique = true, desc = "Move line up" })
map("n", "<A-j>", move_line("down"), { unique = true, desc = "Move line down" })

map("x", "<A-Up>", move_selection("up"), { unique = true, desc = "Move selection up" })
map("x", "<A-Down>", move_selection("down"), { unique = true, desc = "Move selection down" })
map("x", "<A-k>", move_selection("up"), { unique = true, desc = "Move selection up" })
map("x", "<A-j>", move_selection("down"), { unique = true, desc = "Move selection down" })
