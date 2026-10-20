-- =========================================================
-- EDITOR OPTIONS
-- =========================================================
-- Plain `vim.opt` settings only. No keymaps, no plugins.

-- ---------------------------------------------------------
-- Appearance
-- ---------------------------------------------------------

-- Absolute number on the cursor line, relative numbers elsewhere.
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable true-color support.
vim.opt.termguicolors = true

-- Highlight the line where the cursor is located.
vim.opt.cursorline = true

-- Always reserve a column for signs such as diagnostics.
vim.opt.signcolumn = "yes"

-- Keep the Normal and Insert cursor shapes distinct.
-- Left disabled on purpose so the current mode stays visible.
-- vim.opt.guicursor = ""

-- Keep some context visible above/below the cursor.
vim.opt.scrolloff = 8


-- ---------------------------------------------------------
-- Text Wrapping & Spelling
-- ---------------------------------------------------------

-- Wrap long lines instead of scrolling horizontally,
-- breaking at word boundaries.
vim.opt.wrap = true
vim.opt.linebreak = true

-- Spell checking is off globally (:Prompt buffers turn it on).
vim.opt.spell = false


-- ---------------------------------------------------------
-- Indentation
-- ---------------------------------------------------------

-- Insert 2 spaces instead of tab characters.
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2


-- ---------------------------------------------------------
-- Input & Clipboard
-- ---------------------------------------------------------

-- Enable mouse support.
vim.opt.mouse = "a"

-- Use the system clipboard for yank/delete/paste operations.
vim.opt.clipboard = "unnamedplus"

-- Keep undo history after closing a file (stored in
-- ~/.local/state/nvim/undo/). Pairs with auto-save: saving no
-- longer means losing the ability to undo.
vim.opt.undofile = true


-- ---------------------------------------------------------
-- Search
-- ---------------------------------------------------------

-- Ignore case when searching, unless the search contains
-- uppercase letters.
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- ---------------------------------------------------------
-- macOS / Sublime-style Cursor & Selection
-- ---------------------------------------------------------

-- Allow Left/Right to move across the boundary of lines.
vim.opt.whichwrap:append("<,>,[,]")

-- Shift+arrow / mouse selection starts Select mode, like in a
-- regular text editor; moving without Shift stops it.
vim.opt.selectmode = { "key", "mouse" }
vim.opt.keymodel = { "startsel", "stopsel" }
