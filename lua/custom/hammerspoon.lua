-- =========================================================
-- HAMMERSPOON BRIDGE
-- =========================================================
-- Helper module (no side effects): fires a Hammerspoon URL event.
-- The handlers (e.g. "neovide-large", "neovide-normal") are
-- defined outside this repo, in ~/.hammerspoon/init.lua.
--
-- Usage: require("custom.hammerspoon").event("neovide-large")

local M = {}

function M.event(event)
  -- `open -g` sends the URL without bringing Hammerspoon to the front.
  vim.fn.jobstart({
    "open",
    "-g",
    "hammerspoon://" .. event,
  }, {
    detach = true,
  })
end

return M
