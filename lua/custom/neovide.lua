-- =========================================================
-- NEOVIDE (GUI)
-- =========================================================
-- Settings that only matter when running inside Neovide.
-- Window resizing goes through Hammerspoon.

local hammerspoon = require("custom.hammerspoon")

-- Font. Only Neovide reads this; in a terminal the terminal's
-- own font is used.
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMonoNL Nerd Font:h14"
end

-- Treat the LEFT Option key as Meta, so <A-j>/<A-k> etc. work.
-- The right Option key still types special characters.
vim.g.neovide_input_macos_option_key_is_meta = "only_left"

vim.keymap.set("n", "<leader>nl", function()
  hammerspoon.event("neovide-large")
end, { desc = "Enlarge Neovide" })

vim.keymap.set("n", "<leader>nn", function()
  hammerspoon.event("neovide-normal")
end, { desc = "Restore Neovide size" })
