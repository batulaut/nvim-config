-- =========================================================
-- ENTRY POINT
-- =========================================================
-- This file only decides WHAT is loaded and IN WHICH ORDER.
-- Actual settings live in lua/. See STRUCTURE.md for the layout.

-- Leader must be set before any plugin or keymap is defined,
-- otherwise "<leader>" in those mappings resolves to the old key.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Neovim's own behavior (no plugins needed).
require("core.options")

-- Install lazy.nvim and load every spec in lua/plugins/.
require("core.lazy")

-- Built-in remaps and autocmds. Loaded after plugins so that
-- these global mappings are the final word.
require("core.keymaps")
require("core.autocmds")

-- My own small features (no plugin behind them).
require("custom.neovide")
require("custom.move_lines")
require("custom.sentences")
require("custom.prompt")
require("custom.obsidian")
