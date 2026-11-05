-- =========================================================
-- TELESCOPE — File, Search & Project Navigation
-- =========================================================

return {
  {
    "nvim-telescope/telescope.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-project.nvim",
    },

    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local hammerspoon = require("custom.hammerspoon")
      local datafile = require("custom.datafile")

      -- ---------------------------------------------------
      -- Setup
      -- ---------------------------------------------------

      telescope.setup({
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              prompt_position = "bottom",
              preview_height = 0.5,
            },
          },
        },

        extensions = {
          -- telescope-project.nvim: projects listed for <leader>sw.
          -- The folders come from data/projects.txt (see below),
          -- not from `base_dirs`.
          project = {
            hidden_files = false,
            order_by = "recent",
            search_by = { "title", "path" },
            cd_scope = { "global" },
          },
        },
      })

      telescope.load_extension("project")

      -- ---------------------------------------------------
      -- Project folders from data/projects.txt
      -- ---------------------------------------------------
      -- telescope-project keeps its own list of projects in
      -- ~/.local/share/nvim/telescope-projects.txt. This adds
      -- the folders from data/projects.txt to that list:
      --   [git]     searched for repos (what `base_dirs` does)
      --   [folder]  added as-is
      -- Folders already in the list are left alone, so a
      -- project deleted in the picker is not brought back.
      --
      -- Uses telescope-project internals (no public API for
      -- this); if a plugin update breaks it, look here first.
      local project_git = require("telescope._extensions.project.git")

      local PROJECTS_FILE = "projects.txt"
      local synced_mtime = nil

      local function sync_projects()
        local mtime = datafile.mtime(PROJECTS_FILE)
        if mtime == synced_mtime then
          return
        end
        synced_mtime = mtime

        local git_dirs, folders = {}, {}
        local section = nil
        for _, entry in ipairs(datafile.read_lines(PROJECTS_FILE)) do
          if entry == "[git]" or entry == "[folder]" then
            section = entry
          elseif section == "[git]" then
            git_dirs[#git_dirs + 1] = { path = entry }
          elseif section == "[folder]" then
            local path = vim.fs.normalize(entry)
            if vim.fn.isdirectory(path) == 1 then
              folders[#folders + 1] = path
            end
          end
        end

        -- Missing folders are skipped silently (2nd argument).
        project_git.update_git_repos(git_dirs, true)
        project_git.save_git_repos(project_git.parse_git_repo_paths(folders))
      end

      sync_projects()

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

      map("n", "<leader>tb", function()
        builtin.builtin({
          wrap_results = true,
        })
      end, { desc = "Find Telescope builtins" })

      map("n", "<leader>ff", function()
        builtin.find_files({
          wrap_results = true,
        })
      end, { desc = "Find files" })

      -- Live grep needs room: enlarge Neovide while searching and
      -- restore it when the picker closes (Enter, Esc, …).
      map("n", "<leader>fg", function()
        hammerspoon.event("neovide-large")
        builtin.live_grep({
          wrap_results = true,

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

      map("n", "<leader>b", function()
        builtin.buffers({
          wrap_results = true,
        })
      end, { desc = "Find buffers / opened files" })

      -- Recent files (v:oldfiles plus files opened this session).
      -- Telescope's own picker already skips files that no longer
      -- exist and folders.
      map("n", "<leader>fo", function()
        builtin.oldfiles({
          prompt_title = "Recent Files",
          wrap_results = true,
        })
      end, {
        desc = "Find existing recent files",
      })

      map("n", "<leader>fh", function()
        builtin.help_tags({
          wrap_results = true,
        })
      end, { desc = "Find help" })

      map("n", "<leader>sw", function()
        sync_projects()
        -- hide_workspace: drop the "w0" column. Workspaces are an
        -- unfinished telescope-project feature; every project is in w0.
        telescope.extensions.project.project({ hide_workspace = true })
      end, { desc = "Select workspace project" })
    end,
  },
}
