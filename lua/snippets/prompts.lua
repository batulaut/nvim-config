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
local c = ls.choice_node

ls.add_snippets("markdown", {
  s(";ask", {
    t("Yang ingin saya tanyakan: "),
    i(1),
  }),

  s(";cc", {
    t("Claude Code"),
  }),

  s(";compare", {
    t("Bandingkan "),
    i(1, "X"),
    t(" dan "),
    i(2, "Y"),
    t({" berdasarkan:", "- "}),
    i(3),
    t({"", "- "}),
    i(4),
    t({"", "- "}),
    i(5),
  }),

  s(";ctx", {
    t("Konteks saya saat ini: "),
    i(1),
  }),

  s(";goal", {
    t("Tujuan saya: "),
    i(1),
  }),

  s(";prompt", {
    t("Konteks:"),
    t({"", ""}),
    i(1),

    t({"", "", "Tujuan:"}),
    t({"", ""}),
    i(2),

    t({"", "", "Yang sudah saya coba:"}),
    t({"", ""}),
    i(3),

    t({"", "", "Masalah / pertanyaan:"}),
    t({"", ""}),
    i(4),

    t({"", "", "Output yang saya inginkan:"}),
    t({"", ""}),
    i(5),
  }),

  s(";out", {
    c(1, {
      t("Ringkas dan langsung ke poin utama."),
      t("Jelaskan langkah demi langkah."),
      t("Gunakan contoh konkret."),
      t("Gunakan tabel jika membantu perbandingan."),
      t("Berikan penjelasan yang mendalam."),
    }),
  })
})
