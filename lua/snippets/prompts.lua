-- =========================================================
-- PROMPT SNIPPETS (Markdown)
-- =========================================================
-- Snippet definitions only. Loaded by the LuaSnip spec in
-- lua/plugins/completion.lua, which also maps <C-n>/<C-p>
-- for cycling the options of ;out.
--
-- Type the trigger (e.g. ";ask") in a Markdown buffer and
-- accept it from the completion menu.

local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("markdown", {
  s(";ask", {
    t("Yang ingin saya tanyakan: "),
    i(1),
  }),

  s(";cb", {
    t("Sebelum mulai, cek dulu kondisi branch terbaru saat ini."),
    i(1),
  }),

  s(";cc", {
    t("Claude Code"),
  }),

  s(";ctx", {
    t("Konteks saya saat ini: "),
    i(1),
  }),

  s(";goal", {
    t("Tujuan saya: "),
    i(1),
  }),

  s(";jua", {
    t("Jangan ubah apapun dulu sebelum saya memintanya secara eksplisit."),
    i(1),
  }),

  s(";smk", {
    t({
      "Silakan mulai kerja.",
      "Jika ada temuan atau ambiguitas selama kerja, yang sifatnya tidak memblokir, langsung catat ke dokumen.",
      "Kalau ada yang memblokir, pause dulu untuk tanyakan ke saya.",
    }),
    i(1),
  }),

  s(";tisa", {
    t("Tetap ikuti semua aturan yang sudah ada (`CLAUDE.md` dan dokumen lain yang relevan.)"),
    i(1),
  }),

  s(";tcl", {
    t("Tolong cek lagi di kode."),
    i(1),
  })
})
