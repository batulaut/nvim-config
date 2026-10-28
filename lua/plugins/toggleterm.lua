-- =========================================================
-- TOGGLETERM — Persistent Floating Terminal
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
        persist_size = true,

        float_opts = {
          border = "curved",

          -- Responsive size for different Neovide window sizes.
          width = function()
            return math.max(
              20,
              math.min(110, math.floor(vim.o.columns * 0.85))
            )
          end,

          height = function()
            return math.max(
              8,
              math.min(30, math.floor(vim.o.lines * 0.70))
            )
          end,
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
      end, {
        desc = "Terminal: toggle floating terminal",
      })

      -- Terminal-specific keymaps.
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*toggleterm#*",

        callback = function(ev)
          local map_opts = {
            buffer = ev.buf,
            silent = true,
            noremap = true,
          }

          -- Toggle the terminal directly from Terminal mode.
          vim.keymap.set("t", "<C-\\>", function()
            terminal:toggle()
          end, vim.tbl_extend("force", map_opts, {
            desc = "Terminal: hide floating terminal",
          }))

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

          -- Navigate to windows behind the floating terminal.
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
