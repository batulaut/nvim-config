
local obsidian_vault = vim.fn.expand("~/Work/Obsidian/victor-obsd")

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.md",
  callback = function()
    local file = vim.fn.expand("%:p")

    -- Hanya aktif untuk file di dalam Obsidian vault
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
