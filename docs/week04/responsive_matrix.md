App: Drama Vault
Screens: HomeScreen

Kolom 'Sebelum' diisi dari code review awal. Kolom 'Sesudah' diisi setelah
menjalankan tes di emulator di ganti '☐' dengan 'Pass' atau 'Fail'.

| Screen | Test                     | Cara | Sebelum                                                                                                                                    | Fix                                                                                                                                                                                                                               | Sesudah |
|---|--------------------------|---|--------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|
| HomeScreen | Small phone (320 dp)     | Emulator lebar 320 dp | Gagal karena 'DramaList' mengembalikan 'ListView'atau'Center' (box widget) di dalam 'CustomScrollView.slivers', sehingga error saat render | 'DramaList' diubah menjadi sliver ('SliverList.builder' atau 'SliverGrid.builder' atau 'SliverFillRemaining')                                                                                                          | Pass    |
| HomeScreen | Large phone (430 dp)     | Emulator lebar 430 dp | Gagal karena 'DramaList' mengembalikan 'ListView'atau'Center' (box widget) di dalam 'CustomScrollView.slivers', sehingga error saat render | Sama dengan di atas                                                                                                                                                                                                    | Pass       |
| HomeScreen | Tablet (800 dp)          | Emulator lebar 800 dp; layout harus berubah | Gagal karena parameter 'isTablet' diterima tapi tidak dipakai, tidak ada perubahan layout                                                  | 'LayoutBuilder' dengan breakpoint 600 dp: < 600 = list 1 kolom, ≥ 600 = grid ('SliverGridDelegateWithMaxCrossAxisExtent`, maks 420 dp per kolom)                                                 | Pass       |
| HomeScreen | Landscape                | Rotate emulator 320 / 430 / 800 | Gagal karena penyebab sama; tidak ada SafeArea untuk notch                                                                                 | Seluruh halaman scrollable ('CustomScrollView'), 'SafeArea(top: false)' ditambahkan; landscape 430 dp (~932 dp) otomatis masuk layout grid                                                                   | Pass       |
| HomeScreen | Long text (200 karakter) | 'kStressTest = true' di 'home_screen.dart' | Gagal karena 'DramaCard', 'VaultHeader' tanpa 'maxLines' ataupun 'overflow'                                                                | 'maxLines' + 'TextOverflow.ellipsis' di 'DramaCard' (title, subtitle), 'VaultHeader', judul AppBar, "My Watchlist", dan empty state                                                               | Pass       |
| HomeScreen | Empty state              | Cari teks yang tidak ada, mis. 'zzzz' | Gagal karena hanya 'Text('No drama found')' tanpa ikon dan aksi                                                                            | '_EmptyState': ikon 'movie_filter_outlined', pesan, dan tombol 'Reset filters' (memanggil 'onReset')                                                                                                   | Pass       |
| HomeScreen | Long list (500 item)     | 'kStressTest = true' | Gagal karena belum bisa diuji (crash)                                                                                                      | Memakai 'SliverList.builder' atau 'SliverGrid.builder' (lazy); tidak ada 'shrinkWrap: true'                                                                                                                             | Pass       |
| HomeScreen | Keyboard                 | Fokus ke search field di emulator dengan tinggi pendek (landscape) | Gagal karena belum bisa diuji (crash)                                                                                                      | 'Scaffold' meresize body saat keyboard muncul, seluruh konten di dalam 'CustomScrollView' sehingga field bisa discroll ke atas keyboard; 'keyboardDismissBehavior: onDrag'| Pass       |
| HomeScreen | Dark mode                | Ubah emulator ke dark theme | Gagal karena hanya ada 'theme' light dan teks selalu 'kDramaBrown900' (hampir tak terbaca di background gelap)                             | Tambah 'dramaDarkTheme' ('ColorScheme.fromSeed(brightness: dark)'), warna teks brown hanya untuk light mode, 'themeMode: ThemeMode.system'                                                                       | Pass       |

Catatan perubahan lain

- 'DramaSearchBar': 'controller' sebelumnya diterima tapi tidak dipasang ke 'TextField', sehingga 'resetFilters()' tidak mengosongkan teks pencarian. Sekarang sudah dipasang.
- 'DramaList': parameter 'onReset' dan 'isTablet' sebelumnya 'required' tapi tidak dipakai; sekarang dipakai.
- 'lib/lab_harness.dart' ditambahkan sebagai alat uji; 'main.dart' tidak berubah. 'HomeScreen' menerima parameter opsional 'dramas' agar harness bisa mengganti data. 
- Typo data: 'Horor' → 'Horror'.
- 'main.dart': import 'colors.dart' yang tidak dipakai dihapus.

Done
- 'kStressTest' kembali ke 'false'
- Semua kolom 'Sesudah' terisi
- Tidak ada yellow/black stripes di 320, 430, 800 dp (portrait & landscape)