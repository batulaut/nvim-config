-- ---------------------------------------------------------
-- Move Lines
-- ---------------------------------------------------------
-- Option + Up/Down (or Option + K/J):
--   Normal mode: move the current line.
--   Visual mode: move the selected lines as one block.
-- Counts control how many lines the block moves.
--
-- Examples:
--   3<A-j>       Move the current line down 3 lines.
--   Visual + 2<A-k>  Move the selected block up 2 lines.

local M = {}
local map = vim.keymap.set

-- Move a block of lines as one operation.
-- Returns the actual line displacement.
local function move_block(first, last, direction, count)
  local total = vim.api.nvim_buf_line_count(0)

  local steps
  if direction == "up" then
    steps = math.min(count, first - 1)
  else
    steps = math.min(count, total - last)
  end

  if steps <= 0 then
    return 0
  end

  local new_first = direction == "up"
      and (first - steps)
      or (first + steps)

  local new_last = new_first + (last - first)

  if direction == "up" then
    -- Read only the affected region: lines above the block
    -- followed by the block itself.
    local affected = vim.api.nvim_buf_get_lines(
      0, new_first - 1, last, false
    )

    local replacement = {}

    -- Block first.
    for i = steps + 1, #affected do
      replacement[#replacement + 1] = affected[i]
    end

    -- Then the lines previously above the block.
    for i = 1, steps do
      replacement[#replacement + 1] = affected[i]
    end

    vim.api.nvim_buf_set_lines(
      0, new_first - 1, last, false, replacement
    )
  else
    -- Read the block followed by the lines below it.
    local affected = vim.api.nvim_buf_get_lines(
      0, first - 1, new_last, false
    )

    local block_size = last - first + 1
    local replacement = {}

    -- Lines previously below the block.
    for i = block_size + 1, #affected do
      replacement[#replacement + 1] = affected[i]
    end

    -- Then the block itself.
    for i = 1, block_size do
      replacement[#replacement + 1] = affected[i]
    end

    vim.api.nvim_buf_set_lines(
      0, first - 1, new_last, false, replacement
    )
  end

  return new_first - first
end

-- Normal mode
local function move_current_line(direction)
  local count = vim.v.count1
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]

  local delta = move_block(line, line, direction, count)

  if delta ~= 0 then
    vim.api.nvim_win_set_cursor(0, {
      line + delta,
      cursor[2],
    })
  end
end

-- Visual mode
-- The mapping enters command-line mode first so '< and '>
-- refer to the selection that was just made.
function M.move_selection(direction, count)
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local first = math.min(start_pos[2], end_pos[2])
  local last = math.max(start_pos[2], end_pos[2])

  local delta = move_block(first, last, direction, count)

  if delta == 0 then
    return
  end

  -- Update the visual marks to follow the moved block.
  start_pos[2] = start_pos[2] + delta
  end_pos[2] = end_pos[2] + delta

  vim.fn.setpos("'<", start_pos)
  vim.fn.setpos("'>", end_pos)
end

-- Keep Normal-mode callbacks local.
local function normal_move(direction)
  return function()
    move_current_line(direction)
  end
end

-- Use ':' in Visual mode to update the visual marks first.
-- gv restores the selection after the block has moved.
local function visual_move(direction)
  return ":<C-u>lua require('custom.move_lines').move_selection('"
    .. direction
    .. "', vim.v.count1)<CR>gv"
end

-- ---------------------------------------------------------
-- Normal mode
-- ---------------------------------------------------------

map("n", "<A-Up>", normal_move("up"), {
  unique = true,
  desc = "Move line up",
})

map("n", "<A-Down>", normal_move("down"), {
  unique = true,
  desc = "Move line down",
})

map("n", "<A-k>", normal_move("up"), {
  unique = true,
  desc = "Move line up",
})

map("n", "<A-j>", normal_move("down"), {
  unique = true,
  desc = "Move line down",
})

-- ---------------------------------------------------------
-- Visual mode
-- ---------------------------------------------------------

map("x", "<A-Up>", visual_move("up"), {
  unique = true,
  silent = true,
  desc = "Move selection up",
})

map("x", "<A-Down>", visual_move("down"), {
  unique = true,
  silent = true,
  desc = "Move selection down",
})

map("x", "<A-k>", visual_move("up"), {
  unique = true,
  silent = true,
  desc = "Move selection up",
})

map("x", "<A-j>", visual_move("down"), {
  unique = true,
  silent = true,
  desc = "Move selection down",
})

return M
