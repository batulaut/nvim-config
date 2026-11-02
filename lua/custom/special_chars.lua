-- Untuk melihat daftar chars lengkap:
--    :digraphs
--
-- Cara mengeluarkan char dari file ini di mode Insert, misalnya Arrow Right:
--    Ctrl+k
-- lepas, lalu segera tekan:
--    ar


-- Arrows
vim.fn.digraph_set("ar", "→")
vim.fn.digraph_set("ad", "↓")

-- Mathematics (Not Equals)
vim.fn.digraph_set("ne", "≠")

-- Section
vim.fn.digraph_set("se", "§")

-- Writings 
vim.fn.digraph_set("bu", "•")
vim.fn.digraph_set("ck", "✓")
vim.fn.digraph_set("em", "—")
