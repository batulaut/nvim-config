-- =========================================================
-- HAMMERSPOON
-- Cek ~/.hammerspoon/init.lua
-- =========================================================

local M = {}

function M.event(event)
  vim.fn.jobstart({
    "open",
    "-g",
    "hammerspoon://" .. event,
  }, {
    detach = true,
  })
end

return M
