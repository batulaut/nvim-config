-- =========================================================
-- AUTOCMDS
-- =========================================================
-- General automatic behavior. Autocmds that belong to one
-- plugin or one custom feature live in that file instead.

-- ---------------------------------------------------------
-- Auto-save
-- ---------------------------------------------------------

-- Save a modified file automatically when leaving its buffer.
--
-- Skipped for:
-- - special buffers (help, terminal, …): buftype ~= ""
-- - unnamed buffers such as :Prompt, which would otherwise
--   fail with "E32: No file name".
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    local is_normal_buffer = vim.bo.buftype == ""
    local is_modified = vim.bo.modified
    local has_filename = vim.fn.expand("%") ~= ""

    if is_normal_buffer and is_modified and has_filename then
      vim.cmd("silent write")
    end
  end,
})
