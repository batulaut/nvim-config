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
    telescope.lua         telescope + telescope-project + telescope-undo
    git.lua               diffview
    lualine.lua           statusline
    flash.lua             lompat cepat
    completion.lua        blink.cmp + LuaSnip (+ sumber kata dari data/words.txt)
    autolist.lua          lanjutkan/indent list Markdown (berbagi <Tab>/<CR> dengan blink)
    render-markdown.lua   render Markdown (default mati)
  custom/                 Fitur buatan sendiri, tanpa plugin di baliknya
    neovide.lua           Font, tombol Option, resize jendela Neovide
    move_lines.lua        Pindah baris/seleksi dengan Option + panah/j/k
    sentences.lua         Pecah kalimat ke baris baru (<leader>jj / <leader>jk)
    capitalize.lua        Huruf kapital awal kalimat (<leader>ca, Markdown)
    surround.lua          Bungkus seleksi dengan kurung/quote (<leader>su, Markdown)
    prompt.lua            :Prompt (buffer Markdown tanpa nama)
    obsidian.lua          Frontmatter otomatis untuk file baru di vault
    hammerspoon.lua       Helper*: kirim event ke Hammerspoon
    datafile.lua          Helper*: baca file teks di data/
    blink_words.lua       Helper*: sumber blink.cmp untuk data/words.txt
    markdown_text.lua     Helper*: awalan list/kutipan & akhir kalimat (sentences + capitalize)
data/                     Isi yang sering diubah — berlaku TANPA restart Neovim
  words.txt               Kata/istilah sendiri untuk menu autocomplete
  projects.txt            Folder untuk <leader>sw ([git] dan [folder])
  snippets/
    markdown.lua          Snippet untuk buffer Markdown (nama file = filetype)
lazy-lock.json            Versi plugin yang terkunci (ditulis oleh lazy.nvim)

* Helper = modul yang hanya mengembalikan tabel/fungsi, tanpa efek samping saat
  di-require, dan tidak dipanggil dari init.lua.
```

## Prinsip yang dipakai

1. **Kelompokkan berdasarkan alasan berubah.** Satu file berisi hal-hal yang biasanya diubah bersamaan. Contoh: mengganti plugin git cukup membuka `plugins/git.lua` — spec, setup, highlight diff, dan keymap-nya ada di sana semua.
2. **Keymap tinggal bersama pemiliknya.**
   - Keymap plugin → di file plugin itu.
   - Keymap fitur sendiri → di file fitur itu (`custom/…`).
   - `core/keymaps.lua` hanya untuk remap perilaku bawaan Neovim.
   Mencari "tombol X dari mana?" → `:verbose map X` atau cari teks `"X"` di folder yang sesuai.
3. **`init.lua` hanya mengatur urutan.** Semua setting ada di `lua/`. Dengan membaca `init.lua` saja kelihatan apa yang dimuat dan kapan.
4. **Empat jenis folder, empat pertanyaan:**
   - Butuh plugin? → `lua/plugins/`
   - Perilaku bawaan Neovim? → `lua/core/`
   - Buatan sendiri tanpa plugin? → `lua/custom/`
   - Isi/daftar yang sering diubah (bukan logika)? → `data/`
5. **Tanpa abstraksi tambahan.** Tidak ada fungsi `setup()` buatan, tidak ada framework. Fitur di `custom/` langsung bekerja saat di-`require` dari `init.lua`. Helper (modul yang mengembalikan tabel) hanya dibuat bila memang dipakai lebih dari satu tempat (`hammerspoon.lua`, `datafile.lua`) atau diminta oleh plugin (`blink_words.lua` adalah format "source" yang diminta blink.cmp).
6. **Data terpisah dari mesin.** Isi (kata, folder, snippet) ada di `data/`; mesin yang membacanya ada di `lua/`. Menambah isi tidak perlu menyentuh Lua, dan tidak perlu restart:
   - `words.txt` dibaca ulang saat autocomplete berikutnya bila file berubah.
   - `projects.txt` dibaca ulang saat `<leader>sw` dibuka bila file berubah.
   - `snippets/*.lua` dimuat ulang oleh LuaSnip saat disimpan di Neovim (dan, bila file watcher macOS berjalan, juga saat diubah dari editor lain).
7. **Komentar menjelaskan *kenapa*, bukan mengulang kode.** Komentar yang menyebut nilai (mis. `path = 0`) harus cocok dengan nilainya.

## Urutan muat (penting)

Urutan **antar-bagian** di `init.lua` disengaja (urutan di **dalam** satu bagian bebas, mis. alfabetis):

1. **Leader** diset paling awal — keymap `<leader>…` yang dibuat sebelum ini akan memakai leader lama.
2. **`core.options`** — tidak bergantung pada apa pun.
3. **`core.lazy`** — memuat semua plugin. Colorscheme punya `priority = 1000` sehingga dimuat lebih dulu.
4. **`core.keymaps`, `core.autocmds`** — setelah plugin, supaya mapping global ini yang terakhir menang. Keduanya tidak saling bergantung.
5. **`custom.*`** — fitur sendiri; tidak saling bergantung (helper di-`require` sendiri oleh pemakainya, bukan dari `init.lua`). `custom.move_lines` memakai `unique = true`: kalau tombol Option + panah/j/k juga didefinisikan di tempat lain, Neovim menampilkan error saat startup (disengaja, supaya bentrok langsung ketahuan).

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
| Menambah snippet | Edit `data/snippets/markdown.lua`, lalu simpan. Untuk filetype lain buat `data/snippets/<filetype>.lua` (mis. `lua.lua`, `all.lua` untuk semua filetype) dengan bentuk yang sama. **Jangan akhiri snippet dengan `i(n)`** — penjelasannya di header file itu. |
| Menambah kata autocomplete | Tambah satu baris di `data/words.txt`. Spasi boleh ("Claude Code"). |
| Menambah folder project | Tambah satu baris di `data/projects.txt`, di bawah `[git]` (dicari repo git-nya) atau `[folder]` (ditambahkan apa adanya). Menghapus baris tidak menghapus project dari daftar — hapus di picker dengan `<C-d>`. |
| Mengubah tampilan/warna | `plugins/colorscheme.lua` (`custom_highlights`), termasuk warna diff. Jangan pakai `nvim_set_hl` di file lain — hasilnya hilang saat `:colorscheme` dijalankan ulang. |

## Rekomendasi kebiasaan

- **Satu commit = satu perubahan** dengan pesan seperti yang sudah Anda pakai ("Install flash.nvim", "Remap Undo keys"). Struktur per file membuat diff commit tetap kecil dan mudah dibaca.
- **Commit `lazy-lock.json`** setiap kali update plugin (`:Lazy update`), supaya bisa kembali ke versi yang terbukti jalan (`:Lazy restore`).
- **Cek setelah mengubah**: buka Neovim, lihat `:messages` dan `:checkhealth lazy`. Bentrok tombol: `:verbose map <tombol>`.
- **Jangan pecah file terlalu dini.** File besar yang masih satu tanggung jawab tidak apa-apa. Pecah bila satu file mulai berisi dua hal yang berubah karena alasan berbeda.
- **Jangan membuat helper sebelum dipakai di ≥ 2 tempat.** Sampai saat itu, kode ditulis langsung di tempatnya.
- **Hal di luar repo ini** (handler Hammerspoon di `~/.hammerspoon/init.lua`, path vault Obsidian di `custom/obsidian.lua`, folder project di `data/projects.txt`) disebut di komentar file terkait. Bila salah satunya berpindah, cukup ubah satu tempat itu.
