
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.nvim",
    },
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
