-- =========================================================
-- PROMPT SCRATCH BUFFER
-- =========================================================
-- :Prompt opens an unnamed Markdown buffer for drafting text.
-- Being unnamed, it is skipped by auto-save (lua/core/autocmds.lua).
-- Prompt snippets live in lua/snippets/prompts.lua.

vim.api.nvim_create_user_command("Prompt", function()
  vim.cmd("enew")

  -- Treat the buffer as Markdown (enables Markdown snippets).
  vim.bo.filetype = "markdown"

  -- Writing-friendly settings for this buffer only.
  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
  vim.opt_local.breakindent = true
  vim.opt_local.spell = true
end, {})

vim.keymap.set("n", "<leader>p", "<cmd>Prompt<cr>", { desc = "New prompt" })
