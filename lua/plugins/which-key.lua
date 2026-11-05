-- =========================================================
-- WHICH-KEY — Popup with the keys that can follow a prefix
-- =========================================================
-- Shows after 800 ms of waiting, e.g. after <leader>.
-- Normal/Visual/Operator modes only (its default); it does not
-- watch Insert mode keys such as jj / jk.

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 800,
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Show buffer keymaps",
      },
    },
  },
}
