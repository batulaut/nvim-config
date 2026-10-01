local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

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

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.termguicolors = true
vim.opt.cursorline = true
-- vim.opt.guicursor = "" -- Jangan dinyalakan, biar notice beda Normal Mode dan Insert Mode.
vim.opt.signcolumn = "yes"
vim.opt.wrap = true 
vim.opt.spell = true
vim.opt.linebreak = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 8

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
        transparent_background = false,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
        options = {
          globalstatus = true,
        },
      })
    end,
  },
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {
  desc = "Find files",
})

vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
  desc = "Live grep / rg",
})

vim.keymap.set("n", "<leader>fb", builtin.buffers, {
  desc = "Find buffers / opened files",
})

vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
  desc = "Find help",
})


vim.keymap.set("n", "<A-Up>", ":m .-2<CR>", { unique = true })
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>", { unique = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>", { unique = true })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>", { unique = true })

-- vim.keymap.set("n", "<leader>e", function()
--   vim.cmd("split | terminal yazi")
-- end, {
--   desc = "Open Yazi",
-- })

vim.opt.whichwrap:append("<,>,[,]")

-- Selection Mode seperti Sublime
vim.opt.selectmode = { "key", "mouse" }
vim.opt.keymodel = { "startsel", "stopsel" }

vim.keymap.set("i", "<A-BS>", "<C-W>", {
  desc = "Delete previous word",
})

vim.keymap.set("i", "<A-Del>", "<C-O>de", {
  desc = "Delete next word",
})

vim.keymap.set("i", "<D-BS>", "<C-U>", {
  desc = "Delete to beginning of line",
})

vim.keymap.set("i", "<D-Left>", "<Home>", {
  desc = "Beginning of line",
})

vim.keymap.set("i", "<D-Right>", "<End>", {
  desc = "End of line",
})

vim.keymap.set("n", "<D-Left>", "0", {
  desc = "Beginning of line",
})

vim.keymap.set("n", "<D-Right>", "$", {
  desc = "End of line",
})

vim.keymap.set("i", "<D-Up>", "<C-Home>", {
  desc = "Beginning of document",
})

vim.keymap.set("i", "<D-Down>", "<C-End>", {
  desc = "End of document",
})

vim.keymap.set("n", "<D-Up>", "gg", {
  desc = "Beginning of document",
})

vim.keymap.set("n", "<D-Down>", "G", {
  desc = "End of document",
})

vim.keymap.set("i", "<A-Left>", "<C-Left>", {
  desc = "Previous word",
})

vim.keymap.set("i", "<A-Right>", "<C-Right>", {
  desc = "Next word",
})

---------------------------
-- PROMPT BUFFER
---------------------------

local map = vim.keymap.set

vim.api.nvim_create_user_command("Prompt", function()
  vim.cmd("enew")

  vim.bo.filetype = "markdown"

  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
  vim.opt_local.breakindent = true
  vim.opt_local.spell = true
end, {})

map("n", "<leader>p", "<cmd>Prompt<cr>", {
  desc = "New prompt",
})

---------------------------------------------------------------------------
-- AUTO SAVE WHEN LEAVING A FILE BUFFER
---------------------------------------------------------------------------

vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    if vim.bo.buftype == "" and vim.bo.modified then
      vim.cmd("silent write")
    end
  end,
})
