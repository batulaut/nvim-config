-- =========================================================
-- TELESCOPE — File, Search & Project Navigation
-- =========================================================

return {
  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-project.nvim",
      "debugloop/telescope-undo.nvim",
    },

    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local hammerspoon = require("custom.hammerspoon")

      -- ---------------------------------------------------
      -- Setup
      -- ---------------------------------------------------

      telescope.setup({
        extensions = {
          -- telescope-project.nvim: projects listed for <leader>sp.
          project = {
            base_dirs = {
              -- If the folder is not a git repo, then use
              -- `:lua require("telescope._extensions.project.actions").add_project_path(vim.fn.expand("~/Documents/Sublime-Dump"))`
              { path = "~/.config/nvim" },
              { path = "~/Documents/GitHub/plutoman-supabase" },
              { path = "~/Documents/GitHub/plutoman-supabase/claude_tmp/external-clients/plutonet-android" },
              { path = "~/Documents/Sublime-Dump" },
              { path = "~/Work/Obsidian/victor-obsd" },
            },
            hidden_files = false,
            order_by = "recent",
            search_by = { "title", "path" },
            cd_scope = { "global" },
          },

          -- telescope-undo.nvim: search undo history.
          undo = {
            side_by_side = false,
          },
        },
      })

      telescope.load_extension("project")
      telescope.load_extension("undo")

      -- Wrap text in the preview window (except for help pages).
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        callback = function(args)
          if args.data and args.data.filetype ~= "help" then
            vim.wo.wrap = true
            vim.wo.linebreak = true
            vim.wo.breakindent = true
          end
        end,
      })

      -- ---------------------------------------------------
      -- Keymaps
      -- ---------------------------------------------------

      local map = vim.keymap.set

      map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })

      -- Live grep needs room: enlarge Neovide while searching and
      -- restore it when the picker closes (Enter, Esc, …).
      map("n", "<leader>fg", function()
        hammerspoon.event("neovide-large")
        builtin.live_grep({
          attach_mappings = function(prompt_bufnr)
            vim.api.nvim_create_autocmd("BufWipeout", {
              buffer = prompt_bufnr,
              once = true,
              callback = function()
                hammerspoon.event("neovide-normal")
              end,
            })
            -- true = keep Telescope's default mappings.
            return true
          end,
        })
      end, { desc = "Live grep / rg" })

      map("n", "<leader>fb", builtin.buffers, { desc = "Find buffers / opened files" })
      map("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })

      map("n", "<leader>sp", function()
        telescope.extensions.project.project({})
      end, { desc = "Switch project" })

      -- Search the current buffer's undo history.
      -- After finding the text:
      --    Enter: Retrieves the text added by the selected change to the register
      --    Shift+Enter: Retrieves the text deleted by the selected change
      --    Ctrl+Enter: Restores the entire buffer to the state of the selected change
      --    Ctrl+R: Alternative to restore that state
      map("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "Search undo history" })
    end,
  },
}
