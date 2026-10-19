
-- =========================================================
-- GIT / DIFFVIEW
-- =========================================================

-- ---------------------------------------------------------
-- Diffview Window Layout
-- ---------------------------------------------------------

local hammerspoon = require("config.hammerspoon")

local function resize_diffview_windows()
  vim.defer_fn(function()
    vim.cmd("horizontal wincmd =")
  end, 300)
end


-- ---------------------------------------------------------
-- Diffview Setup
-- ---------------------------------------------------------

local function next_change()
  vim.cmd("normal! ]c")
end

local function prev_change()
  vim.cmd("normal! [c")
end

require("diffview").setup({
  hooks = {
    view_opened = function()
      hammerspoon.event("neovide-large")
      resize_diffview_windows()
    end,

    view_closed = function()
      hammerspoon.event("neovide-normal")
    end,
  },

  keymaps = {
    view = {
      {
        "n",
        "S",
        next_change,
        { desc = "Next diff change" },
      },
      {
        "n",
        "W",
        prev_change,
        { desc = "Previous diff change" },
      },
    },
  },
})


-- ---------------------------------------------------------
-- Diff Highlights
-- ---------------------------------------------------------

vim.api.nvim_set_hl(0, "DiffAdd", {
  bg = "#284d3a",
})

vim.api.nvim_set_hl(0, "DiffChange", {
    bg = "#3f3b2f",
})

vim.api.nvim_set_hl(0, "DiffText", {
  bg = "#8a6338",
  fg = "#ffe8b6",
  bold = true,
})


-- =========================================================
-- GIT KEYMAPS
-- =========================================================

-- Open Git diff view.
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", {
  desc = "Git diff",
})

-- Open Git file history.
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", {
  desc = "Git file history",
})

-- Close Diffview.
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<cr>", {
  desc = "Git diff close",
})
