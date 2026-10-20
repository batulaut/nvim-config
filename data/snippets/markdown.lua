-- =========================================================
-- MARKDOWN SNIPPETS
-- =========================================================
-- Loaded by LuaSnip (see lua/plugins/completion.lua). Every
-- file in data/snippets/ is named after a filetype; this one
-- applies to Markdown buffers.
--
-- Saving this file inside Neovim reloads it immediately, and
-- edits from another editor are picked up too — no restart.
--
-- Type the trigger (e.g. ";ask") and accept it from the
-- completion menu. Helpers such as s, t, i, c and fmt are
-- provided by LuaSnip; nothing needs to be required here.
--   s(trigger, nodes)  a snippet
--   t("text")          fixed text ({ "a", "b" } = two lines)
--   i(1)               cursor stop; Tab jumps to the next one

return {
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
  }),
}
