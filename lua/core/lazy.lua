-- =========================================================
-- LAZY.NVIM (plugin manager)
-- =========================================================

-- Location where lazy.nvim will be installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Install lazy.nvim automatically if it is not installed yet.
if not vim.uv.fs_stat(lazypath) then
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

-- Every file in lua/plugins/ returns one or more plugin specs.
-- Adding a plugin = adding a file there; nothing to edit here.
require("lazy").setup({
  { import = "plugins" },
})
