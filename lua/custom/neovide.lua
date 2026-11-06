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

  vim.g.neovide_padding_top = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_left = 12
  vim.g.neovide_padding_right = 12

  vim.g.neovide_remember_window_size = true

  vim.g.neovide_opacity = 0.85
  vim.g.neovide_normal_opacity = 0.85

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_confirm_quit = true

  vim.g.neovide_highlight_matching_pair = true

  -- Treat the LEFT Option key as Meta, so <A-j>/<A-k> etc. work.
  -- The right Option key still types special characters.
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
end

vim.keymap.set("n", "<leader>nl", function()
  hammerspoon.event("neovide-large")
end, { desc = "Enlarge Neovide" })

vim.keymap.set("n", "<leader>nn", function()
  hammerspoon.event("neovide-normal")
end, { desc = "Restore Neovide size" })
