-- =========================================================
-- AUTOLIST — Markdown list continuation and formatting
-- =========================================================
return {
  {
    "gaoDean/autolist.nvim",
    ft = { "markdown" },
    config = function()
      require("autolist").setup()

      local map = vim.keymap.set

      -- Continue lists automatically.
      map("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>",
        { buffer = true, desc = "Continue Markdown list" })

      map("n", "o", "o<cmd>AutolistNewBullet<cr>",
        { buffer = true, desc = "New Markdown list item" })

      map("n", "O", "O<cmd>AutolistNewBulletBefore<cr>",
        { buffer = true, desc = "New Markdown list item above" })

      -- Indent / dedent list items.
      map("i", "<Tab>", "<cmd>AutolistTab<cr>",
        { buffer = true, desc = "Indent Markdown list" })

      map("i", "<S-Tab>", "<cmd>AutolistShiftTab<cr>",
        { buffer = true, desc = "Dedent Markdown list" })

      -- Recalculate ordered lists.
      map("n", "<leader>mr", "<cmd>AutolistRecalculate<cr>",
        { buffer = true, desc = "Recalculate Markdown lists" })
    end,
  },
}
