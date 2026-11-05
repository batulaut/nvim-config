-- =========================================================
-- AUTOCMDS
-- =========================================================
-- General automatic behavior. Autocmds that belong to one
-- plugin or one custom feature live in that file instead.

-- ---------------------------------------------------------
-- Auto-save
-- ---------------------------------------------------------

-- Save a modified file automatically when leaving its buffer
-- (BufLeave) or when switching to another app (FocusLost).
--
-- Skipped for:
-- - special buffers (help, terminal, …): buftype ~= ""
-- - unnamed buffers such as :Prompt, which would otherwise
--   fail with "E32: No file name".
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function()
    local is_normal_buffer = vim.bo.buftype == ""
    local is_modified = vim.bo.modified
    local has_filename = vim.fn.expand("%") ~= ""

    if is_normal_buffer and is_modified and has_filename then
      vim.cmd("silent write")
    end
  end,
})


-- ---------------------------------------------------------
-- Bottom Context for Prose
-- ---------------------------------------------------------

-- In Markdown and text files, keep about 12 lines visible below
-- the cursor: when the cursor gets closer to the bottom of the
-- window, center it (zz). Normal mode only (CursorMoved).
--
-- One autocmd for all buffers (checking the filetype) rather
-- than one per buffer, so nothing piles up when a buffer's
-- FileType event fires again.
local BOTTOM_CONTEXT = 12

vim.api.nvim_create_autocmd("CursorMoved", {
  group = vim.api.nvim_create_augroup("ProseBottomContext", { clear = true }),
  callback = function()
    local filetype = vim.bo.filetype
    if filetype ~= "markdown" and filetype ~= "text" then
      return
    end

    -- winline(): the cursor's screen line inside this window,
    -- counting wrapped lines. In a short window, ask for less
    -- than half its height, or zz would fire on every move.
    local height = vim.fn.winheight(0)
    local wanted = math.min(BOTTOM_CONTEXT, math.floor(height / 2) - 1)

    if height - vim.fn.winline() < wanted then
      vim.cmd("normal! zz")
    end
  end,
})


-- ---------------------------------------------------------
-- Reload Notice
-- ---------------------------------------------------------

-- 'autoread' (on by default) silently replaces a buffer's text
-- when its file was changed by another program (a second
-- Neovim, Obsidian, Claude Code, a sync tool) while the buffer
-- had no unsaved changes — for example right after auto-save.
-- Neovim checks this when it regains focus and when entering a
-- buffer. Make it visible, so "disappearing" text can be traced;
-- U (undo) brings the previous text back.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function(args)
    vim.notify(
      "Reloaded from disk (changed outside Neovim): " .. vim.fn.fnamemodify(args.file, ":~:."),
      vim.log.levels.WARN
    )
  end,
})
