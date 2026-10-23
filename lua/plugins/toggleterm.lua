-- =========================================================
-- TOGGLETERM — Terminal inside Neovim
-- =========================================================

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",

    config = function()
      require("toggleterm").setup({
        shell = "/bin/zsh",
        direction = "float",
        start_in_insert = true,
        close_on_exit = false,
        float_opts = {
          border = "curved",
          width = 90,
          height = 25,
        },
      })

      -- Prevent creating a new terminal instance every time toggle is called.
      local Terminal = require("toggleterm.terminal").Terminal
      local terminal = Terminal:new({
        id = 1,
        direction = "float",
        hidden = true,
        close_on_exit = false,
      })

      vim.keymap.set("n", "<C-\\>", function()
        terminal:toggle()
      end, { desc = "Toggle single floating terminal" })

      -- Terminal-specific keymaps.
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*toggleterm#*",
        callback = function(ev)
          local map_opts = {
            buffer = ev.buf,
            silent = true,
            noremap = true,
          }

          -- Leave Terminal mode without closing the terminal.
          vim.keymap.set(
            "t",
            "<C-q>",
            [[<C-\><C-n>]],
            vim.tbl_extend("force", map_opts, {
              desc = "Terminal: enter Normal mode",
            })
          )
          vim.keymap.set(
            "t",
            "jj",
            [[<C-\><C-n>]],
            vim.tbl_extend("force", map_opts, {
              desc = "Terminal: enter Normal mode",
            })
          )
          vim.keymap.set(
            "t",
            "jk",
            [[<C-\><C-n>]],
            vim.tbl_extend("force", map_opts, {
              desc = "Terminal: enter Normal mode",
            })
          )

          -- Navigate between Neovim windows.
          for key, direction in pairs({
            h = "h",
            j = "j",
            k = "k",
            -- l = "l", Don't use `<C-l>` since it needed to clear terminal.
          }) do
            vim.keymap.set(
              "t",
              "<C-" .. key .. ">",
              [[<C-\><C-n><C-w>]] .. direction,
              vim.tbl_extend("force", map_opts, {
                desc = "Terminal: move to window " .. direction,
              })
            )
          end
        end,
      })
    end,
  },
}
