
-- =========================================================
-- LAZY.NVIM BOOTSTRAP
-- =========================================================

-- Location where lazy.nvim will be installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Install lazy.nvim automatically if it is not installed yet.
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- Add lazy.nvim to Neovim's runtime path.
vim.opt.rtp:prepend(lazypath)


-- =========================================================
-- LEADER KEYS
-- =========================================================

-- Space is the leader key.
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- =========================================================
-- EDITOR OPTIONS
-- =========================================================

-- Show absolute line numbers.
vim.opt.number = true

-- Show relative line numbers.
vim.opt.relativenumber = true

-- Enable true-color support.
vim.opt.termguicolors = true

-- Highlight the line where the cursor is located.
vim.opt.cursorline = true

-- Keep the Normal and Insert cursor shapes distinct.
-- Disabled intentionally so the current mode remains visually noticeable.
-- vim.opt.guicursor = ""

-- Always reserve a column for signs such as diagnostics.
vim.opt.signcolumn = "yes"

-- Font — Only works for Neovide, not Neovim in Terminal.
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMonoNL Nerd Font:h14"
end

-- ---------------------------------------------------------
-- Text Wrapping & Spelling
-- ---------------------------------------------------------

-- Wrap long lines instead of scrolling horizontally.
vim.opt.wrap = true

-- Enable spell checking.
vim.opt.spell = false

-- Prefer breaking wrapped lines at word boundaries.
vim.opt.linebreak = true


-- ---------------------------------------------------------
-- Indentation
-- ---------------------------------------------------------

-- Insert spaces instead of tab characters.
vim.opt.expandtab = true

-- Number of spaces used for each indentation level.
vim.opt.shiftwidth = 2

-- Number of spaces a <Tab> represents.
vim.opt.tabstop = 2


-- ---------------------------------------------------------
-- Input & Clipboard
-- ---------------------------------------------------------

-- Enable mouse support.
vim.opt.mouse = "a"

-- Use the system clipboard for yank/delete/paste operations.
vim.opt.clipboard = "unnamedplus"


-- ---------------------------------------------------------
-- Search
-- ---------------------------------------------------------

-- Ignore case when searching...
vim.opt.ignorecase = true

-- ...unless the search contains uppercase letters.
vim.opt.smartcase = true

vim.keymap.set("n", "<leader>fp", function()
  local path = vim.fn.expand("%:p")
  print(path)
  vim.fn.setreg("+", path)
end, { desc = "Show & copy absolute file path" })


-- ---------------------------------------------------------
-- Scrolling
-- ---------------------------------------------------------

-- Keep some context visible above/below the cursor.
vim.opt.scrolloff = 8


-- ---------------------------------------------------------
-- Line Movement
-- ---------------------------------------------------------

-- Move by visual lines when text is wrapped.
vim.keymap.set("n", "j", "gj", {
  desc = "Move down by visual line",
})

vim.keymap.set("n", "k", "gk", {
  desc = "Move up by visual line",
})

-- =========================================================
-- PLUGINS
-- =========================================================

require("lazy").setup({

  -- -------------------------------------------------------
  -- Catppuccin — Colorscheme
  -- -------------------------------------------------------

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
        transparent_background = false,

        custom_highlights = function(colors)
          return {
            WinSeparator = {
              fg = colors.blue,
            },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },


  -- -------------------------------------------------------
  -- Telescope — File & Search Navigation
  -- -------------------------------------------------------

  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },


  -- -------------------------------------------------------
  -- Diffview — See git diff
  -- -------------------------------------------------------

  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- -------------------------------------------------------
  -- Lualine — Statusline
  -- -------------------------------------------------------

  {
    "nvim-lualine/lualine.nvim",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("config.lualine")
    end,
  },


  -- -------------------------------------------------------
  -- Blink.cmp — Text Completion
  -- -------------------------------------------------------
  
  {
    "saghen/blink.cmp",

    dependencies = {
      "saghen/blink.lib",
      "L3MON4D3/LuaSnip",
    },

    build = function()
      require("blink.cmp").build():pwait()
    end,

    opts = {
      keymap = {
        preset = "super-tab",
      },

      completion = {
        documentation = {
          auto_show = false,
        },

        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
      },

      -- For now, use Lua fuzzy matcher instead of the native Rust matcher.
      fuzzy = {
        implementation = "lua",
      },

      sources = {
        default = {
          "snippets",
          "buffer",
        },

        providers = {
          buffer = {
            opts = {
              get_bufnrs = function()
                return vim.tbl_filter(function(bufnr)
                  return vim.bo[bufnr].buftype == ""
                end, vim.api.nvim_list_bufs())
              end,
            },
          },
        },
      },

      snippets = {
        preset = "luasnip",
      },
    },
  },
})

require("snippets.prompts")
require("custom.obsidian")
require("config.git")


-- =========================================================
-- TELESCOPE KEYMAPS
-- =========================================================

local builtin = require("telescope.builtin")

-- Find files in the current project.
vim.keymap.set("n", "<leader>ff", builtin.find_files, {
  desc = "Find files",
})

-- Search text across the project using ripgrep.
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
  desc = "Live grep / rg",
})

-- Browse currently opened buffers.
vim.keymap.set("n", "<leader>fb", builtin.buffers, {
  desc = "Find buffers / opened files",
})

-- Search Neovim's built-in help.
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
  desc = "Find help",
})


-- =========================================================
-- MACOS / SUBLIME COMPATIBILITY
-- =========================================================

-- ---------------------------------------------------------
-- Move Lines
-- ---------------------------------------------------------

-- Option + Up/Down: move the current line.
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>", {
  unique = true,
})

vim.keymap.set("n", "<A-Down>", ":m .+1<CR>", {
  unique = true,
})

-- Option + K/J: alternative shortcuts for moving lines.
vim.keymap.set("n", "<A-k>", ":m .-2<CR>", {
  unique = true,
})

vim.keymap.set("n", "<A-j>", ":m .+1<CR>", {
  unique = true,
})


-- ---------------------------------------------------------
-- Horizontal Cursor Movement
-- ---------------------------------------------------------

-- Allow Left/Right to move across the boundary of wrapped lines.
vim.opt.whichwrap:append("<,>,[,]")


-- ---------------------------------------------------------
-- Selection Behavior
-- ---------------------------------------------------------

-- Allow Shift/selection-style behavior from keys and mouse.
vim.opt.selectmode = { "key", "mouse" }

-- Start/stop selection according to the current cursor movement.
vim.opt.keymodel = { "startsel", "stopsel" }


-- ---------------------------------------------------------
-- Word Deletion
-- ---------------------------------------------------------

-- Option + Backspace: delete the previous word.
vim.keymap.set("i", "<A-BS>", "<C-W>", {
  desc = "Delete previous word",
})

-- Option + Delete: delete the next word.
vim.keymap.set("i", "<A-Del>", "<C-O>de", {
  desc = "Delete next word",
})

-- Command + Backspace: delete from cursor to the beginning of the line.
vim.keymap.set("i", "<D-BS>", "<C-U>", {
  desc = "Delete to beginning of line",
})


-- ---------------------------------------------------------
-- Beginning / End of Line
-- ---------------------------------------------------------

-- Insert mode: Command + Left/Right.
vim.keymap.set("i", "<D-Left>", "<Home>", {
  desc = "Beginning of line",
})

vim.keymap.set("i", "<D-Right>", "<End>", {
  desc = "End of line",
})

-- Normal mode: Command + Left/Right.
vim.keymap.set("n", "<D-Left>", "0", {
  desc = "Beginning of line",
})

vim.keymap.set("n", "<D-Right>", "$", {
  desc = "End of line",
})


-- ---------------------------------------------------------
-- Beginning / End of Document
-- ---------------------------------------------------------

-- Insert mode: Command + Up/Down.
vim.keymap.set("i", "<D-Up>", "<C-Home>", {
  desc = "Beginning of document",
})

vim.keymap.set("i", "<D-Down>", "<C-End>", {
  desc = "End of document",
})

-- Normal mode: Command + Up/Down.
vim.keymap.set("n", "<D-Up>", "gg", {
  desc = "Beginning of document",
})

vim.keymap.set("n", "<D-Down>", "G", {
  desc = "End of document",
})


-- ---------------------------------------------------------
-- Word Navigation
-- ---------------------------------------------------------

-- Option + Left/Right: move one word at a time.
vim.keymap.set("i", "<A-Left>", "<C-Left>", {
  desc = "Previous word",
})

vim.keymap.set("i", "<A-Right>", "<C-Right>", {
  desc = "Next word",
})


-- =========================================================
-- PROMPT SCRATCH BUFFER
-- =========================================================

-- Short alias for vim.keymap.set().
local map = vim.keymap.set


-- ---------------------------------------------------------
-- :Prompt
-- ---------------------------------------------------------

-- Create a new buffer intended for writing prompts.
vim.api.nvim_create_user_command("Prompt", function()
  vim.cmd("enew")

  -- Treat the buffer as Markdown.
  vim.bo.filetype = "markdown"

  -- Prompt-specific writing preferences.
  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
  vim.opt_local.breakindent = true
  vim.opt_local.spell = true
end, {})


-- Space + P: create a new prompt buffer.
map("n", "<leader>p", "<cmd>Prompt<cr>", {
  desc = "New prompt",
})


-- =========================================================
-- AUTO-SAVE
-- =========================================================

-- Automatically save a modified normal file when leaving its buffer.
--
-- buftype == "" means this is a normal buffer rather than a
-- special buffer such as help, terminal, etc.
--
-- A filename check prevents unnamed buffers such as :Prompt
-- from triggering :write and causing "E32: No file name".
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    local is_normal_buffer = vim.bo.buftype == ""
    local is_modified = vim.bo.modified
    local has_filename = vim.fn.expand("%") ~= ""

    if is_normal_buffer and is_modified and has_filename then
      vim.cmd("silent write")
    end
  end,
})

