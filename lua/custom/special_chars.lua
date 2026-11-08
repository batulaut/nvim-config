-- =========================================================
-- SPECIAL CHARACTERS (digraphs)
-- =========================================================
-- Extra digraphs. In Insert mode press Ctrl+k, release, then
-- the two letters: Ctrl+k a r → "→".
-- Full list (built-in ones included): :digraphs

-- Arrows
vim.fn.digraph_set("ar", "→")
vim.fn.digraph_set("ad", "↓")

-- Mathematics (Not Equals)
vim.fn.digraph_set("ne", "≠")
vim.fn.digraph_set("ge", "≥")
vim.fn.digraph_set("le", "≤")

-- Section
vim.fn.digraph_set("se", "§")

-- Writing
vim.fn.digraph_set("bu", "•")
vim.fn.digraph_set("ck", "✓")
vim.fn.digraph_set("em", "—")
vim.fn.digraph_set("td", "…")
