# Struktur & Panduan Maintain

Dokumen ini menjelaskan cara konfigurasi ini diorganisasi dan aturan sederhana untuk menambah/mengubahnya.
Gambaran umum (tujuan, environment, tool yang terpasang) ada di [README.md](README.md).

## Peta file

```
init.lua                  Titik masuk: leader + urutan require. Tidak berisi setting.
lua/
  core/                   Perilaku bawaan Neovim, tanpa plugin
    options.lua           vim.opt saja
    lazy.lua              Bootstrap lazy.nvim + import lua/plugins/
    keymaps.lua           Remap perilaku bawaan (jj, U/u, J/K, gaya macOS/Sublime, …)
    autocmds.lua          Autocmd umum (auto-save)
  plugins/                Satu file = satu plugin (atau satu kelompok plugin yang saling butuh)
    colorscheme.lua       catppuccin
    telescope.lua         telescope + telescope-project
    git.lua               diffview
    lualine.lua           statusline
    flash.lua             lompat cepat
    completion.lua        blink.cmp + LuaSnip
    render-markdown.lua   render Markdown (default mati)
  custom/                 Fitur buatan sendiri, tanpa plugin di baliknya
    hammerspoon.lua       Helper (tanpa efek samping): kirim event ke Hammerspoon
    neovide.lua           Font, tombol Option, resize jendela Neovide
    sentences.lua         Pecah kalimat ke baris baru
    prompt.lua            :Prompt (buffer Markdown tanpa nama)
    obsidian.lua          Frontmatter otomatis untuk file baru di vault
  snippets/
    prompts.lua           Isi snippet Markdown (data saja)
lazy-lock.json            Versi plugin yang terkunci (ditulis oleh lazy.nvim)
```

## Prinsip yang dipakai

1. **Kelompokkan berdasarkan alasan berubah.** Satu file berisi hal-hal yang biasanya diubah bersamaan. Contoh: mengganti plugin git cukup membuka `plugins/git.lua` — spec, setup, highlight diff, dan keymap-nya ada di sana semua.
2. **Keymap tinggal bersama pemiliknya.**
   - Keymap plugin → di file plugin itu.
   - Keymap fitur sendiri → di file fitur itu (`custom/…`).
   - `core/keymaps.lua` hanya untuk remap perilaku bawaan Neovim.
   Mencari "tombol X dari mana?" → `:verbose map X` atau cari teks `"X"` di folder yang sesuai.
3. **`init.lua` hanya mengatur urutan.** Semua setting ada di `lua/`. Dengan membaca `init.lua` saja kelihatan apa yang dimuat dan kapan.
4. **Tiga jenis folder, tiga pertanyaan:**
   - Butuh plugin? → `plugins/`
   - Perilaku bawaan Neovim? → `core/`
   - Buatan sendiri tanpa plugin? → `custom/`
5. **Tanpa abstraksi tambahan.** Tidak ada fungsi `setup()` buatan, tidak ada util pembungkus, tidak ada framework. Modul di `custom/` langsung bekerja saat di-`require`. Satu-satunya modul yang mengembalikan tabel (`custom/hammerspoon.lua`) adalah helper yang dipakai di 3 tempat — itu alasan ia ada.
6. **Data terpisah dari mesin.** `snippets/prompts.lua` hanya berisi snippet; mesin (LuaSnip) dan tombolnya diatur di `plugins/completion.lua`. Menambah snippet tidak perlu menyentuh konfigurasi plugin.
7. **Komentar menjelaskan *kenapa*, bukan mengulang kode.** Komentar yang menyebut nilai (mis. `path = 0`) harus cocok dengan nilainya.

## Urutan muat (penting)

Urutan di `init.lua` disengaja:

1. **Leader** diset paling awal — keymap `<leader>…` yang dibuat sebelum ini akan memakai leader lama.
2. **`core.options`** — tidak bergantung pada apa pun.
3. **`core.lazy`** — memuat semua plugin. Colorscheme punya `priority = 1000` sehingga dimuat lebih dulu.
4. **`core.keymaps`, `core.autocmds`** — setelah plugin, supaya mapping global ini yang terakhir menang.
5. **`custom.*`** — fitur sendiri.

Catatan: sebagian besar plugin di sini **tidak lazy** (dimuat saat startup), sama seperti sebelum reorganisasi. Yang lazy: `flash.nvim` (lewat `keys`/`VeryLazy`) dan `render-markdown.nvim` (lewat `ft = markdown`).

## Resep cepat

| Ingin… | Lakukan |
|---|---|
| Menambah plugin | Buat `lua/plugins/<nama>.lua` yang `return { { "author/repo", … } }`. Tidak perlu mengubah file lain. |
| Menghapus plugin | Hapus file-nya, buka Neovim, jalankan `:Lazy clean`. Cek apakah ada `require("<plugin>")` di file lain (`rg 'require\("<plugin>'`). |
| Menambah keymap plugin | Di file plugin: `keys = { … }` bila plugin itu lazy, atau `vim.keymap.set` di dalam `config` bila tidak. Ikuti gaya yang sudah ada di file itu. |
| Menambah keymap umum | `core/keymaps.lua`, di bagian yang sesuai. Selalu isi `desc`. |
| Menambah opsi | `core/options.lua`, di bagian yang sesuai. |
| Menambah fitur sendiri | Buat `lua/custom/<fitur>.lua` (command/autocmd/keymap-nya di file itu), lalu tambahkan `require("custom.<fitur>")` di `init.lua`. |
| Menambah snippet | `lua/snippets/prompts.lua`, atau file baru di `lua/snippets/` + `require` di `config` LuaSnip (`plugins/completion.lua`). |
| Mengubah tampilan/warna | `plugins/colorscheme.lua` (`custom_highlights`), termasuk warna diff. Jangan pakai `nvim_set_hl` di file lain — hasilnya hilang saat `:colorscheme` dijalankan ulang. |

## Rekomendasi kebiasaan

- **Satu commit = satu perubahan** dengan pesan seperti yang sudah Anda pakai ("Install flash.nvim", "Remap Undo keys"). Struktur per file membuat diff commit tetap kecil dan mudah dibaca.
- **Commit `lazy-lock.json`** setiap kali update plugin (`:Lazy update`), supaya bisa kembali ke versi yang terbukti jalan (`:Lazy restore`).
- **Cek setelah mengubah**: buka Neovim, lihat `:messages` dan `:checkhealth lazy`. Bentrok tombol: `:verbose map <tombol>`.
- **Jangan pecah file terlalu dini.** File besar yang masih satu tanggung jawab tidak apa-apa. Pecah bila satu file mulai berisi dua hal yang berubah karena alasan berbeda.
- **Jangan membuat helper sebelum dipakai di ≥ 2 tempat.** Sampai saat itu, kode ditulis langsung di tempatnya.
- **Hal di luar repo ini** (handler Hammerspoon di `~/.hammerspoon/init.lua`, path vault Obsidian, path project di `plugins/telescope.lua`) disebut di komentar file terkait. Bila salah satunya berpindah, cukup ubah satu tempat itu.
