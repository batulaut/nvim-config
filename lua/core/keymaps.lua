-- =========================================================
-- GENERAL KEYMAPS
-- =========================================================
-- Remaps of Neovim's built-in behavior only.
-- Plugin keymaps live in that plugin's file in lua/plugins/.
-- Keymaps of my own features live in that feature's file in
-- lua/custom/.

local map = vim.keymap.set


-- ---------------------------------------------------------
-- Vim Habits
-- ---------------------------------------------------------

-- jj: alternative escape from Insert mode.
map("i", "jj", "<Esc>", { desc = "Change Insert Mode to Normal Mode" })

-- Undo lives on U; plain u is disabled to avoid accidental undo.
map("n", "U", "u", { desc = "Undo" })
map("n", "u", "<Nop>")

-- Esc in Normal mode clears the search highlight.
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- J/K move by visual line, which matters with wrapped text.
map("n", "J", "gj", { desc = "Move down by visual line" })
map("n", "K", "gk", { desc = "Move up by visual line" })

-- The original J/K, moved behind leader:
--   <leader>J  join the next line onto this one (3<leader>J joins 3 lines)
--   <leader>K  help for the word under the cursor (e.g. on `scrolloff`
--              in a .lua file it opens :help 'scrolloff')
-- In Visual mode plain J still joins the selected lines.
map("n", "<leader>J", "J", { desc = "Join lines" })
map("n", "<leader>K", "K", { desc = "Help for word under cursor" })


-- ---------------------------------------------------------
-- File
-- ---------------------------------------------------------

map("n", "<leader>fp", function()
  local path = vim.fn.expand("%:p")
  print(path)
  vim.fn.setreg("+", path)
end, { desc = "Show & copy absolute file path" })


-- =========================================================
-- MACOS / SUBLIME COMPATIBILITY
-- =========================================================
-- Option = <A-…>, Command = <D-…>. Command keys usually only
-- reach Neovim inside Neovide; terminals tend to keep them.
-- Option-as-Meta for Neovide is set in lua/custom/neovide.lua.

-- ---------------------------------------------------------
-- Move Lines
-- ---------------------------------------------------------

-- Option + Up/Down (or Option + K/J): move the current line.
-- unique = true: fail loudly if something else already uses these keys.
map("n", "<A-Up>", ":m .-2<CR>", { unique = true })
map("n", "<A-Down>", ":m .+1<CR>", { unique = true })
map("n", "<A-k>", ":m .-2<CR>", { unique = true })
map("n", "<A-j>", ":m .+1<CR>", { unique = true })


-- ---------------------------------------------------------
-- Word Navigation & Deletion (Insert mode)
-- ---------------------------------------------------------

-- Option + Left/Right: move one word at a time.
map("i", "<A-Left>", "<C-Left>", { desc = "Previous word" })
map("i", "<A-Right>", "<C-Right>", { desc = "Next word" })

-- Option + Backspace / Delete: delete the previous / next word.
map("i", "<A-BS>", "<C-W>", { desc = "Delete previous word" })
map("i", "<A-Del>", "<C-O>de", { desc = "Delete next word" })

-- Command + Backspace: delete from cursor to the beginning of the line.
map("i", "<D-BS>", "<C-U>", { desc = "Delete to beginning of line" })


-- ---------------------------------------------------------
-- Beginning / End of Line (Command + Left/Right)
-- ---------------------------------------------------------

map("i", "<D-Left>", "<Home>", { desc = "Beginning of line" })
map("i", "<D-Right>", "<End>", { desc = "End of line" })
map("n", "<D-Left>", "0", { desc = "Beginning of line" })
map("n", "<D-Right>", "$", { desc = "End of line" })


-- ---------------------------------------------------------
-- Beginning / End of Document (Command + Up/Down)
-- ---------------------------------------------------------

map("i", "<D-Up>", "<C-Home>", { desc = "Beginning of document" })
map("i", "<D-Down>", "<C-End>", { desc = "End of document" })
map("n", "<D-Up>", "gg", { desc = "Beginning of document" })
map("n", "<D-Down>", "G", { desc = "End of document" })
