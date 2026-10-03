local ls = require("luasnip")

vim.keymap.set({ "i", "s" }, "<C-n>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, {
  silent = true,
  desc = "Next snippet choice",
})

vim.keymap.set({ "i", "s" }, "<C-p>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end, {
  silent = true,
  desc = "Previous snippet choice",
})

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

ls.add_snippets("markdown", {
  -- -------------------------------------------------------
  -- Prompt structure
  -- -------------------------------------------------------
  
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
