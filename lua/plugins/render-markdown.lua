-- =========================================================
-- RENDER-MARKDOWN — In-buffer Markdown rendering
-- =========================================================
-- Off by default; toggle per session with <leader>me / <leader>md.

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      enabled = false,
    },
    keys = {
      {
        "<leader>me",
        function()
          require("render-markdown").enable()
        end,
        desc = "Enable Markdown Rendering",
      },
      {
        "<leader>md",
        function()
          require("render-markdown").disable()
        end,
        desc = "Disable Markdown Rendering",
      },
    },
  },
}
