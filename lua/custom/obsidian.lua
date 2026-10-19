-- =========================================================
-- OBSIDIAN FRONTMATTER
-- =========================================================
-- A new .md file created inside the Obsidian vault starts with
-- a "created:" frontmatter block. Files elsewhere are untouched.

local obsidian_vault = vim.fn.expand("~/Work/Obsidian/victor-obsd")

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.md",
  callback = function()
    local file = vim.fn.expand("%:p")

    -- Only for files inside the Obsidian vault.
    if not vim.startswith(file, obsidian_vault .. "/") then
      return
    end

    local lines = {
      "---",
      "created: " .. os.date("%Y-%m-%d %H:%M"),
      "---",
      "",
    }

    vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
  end,
})
