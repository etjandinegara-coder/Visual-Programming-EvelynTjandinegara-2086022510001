Evelyn Tjandinegara (2086022510001)


**The Fandom Vault: Drama Vault**
Aplikasi Flutter untuk melacak, mengatur, dan mencatat drama favorit (K-Drama, C-Drama, dan sejenisnya).

**Studi kasus**

Track yang dipilih adalah Track A: The Fandom Vault (Collection and Log Tracker), dengan use case Drama Watchlist.
Penggemar drama sering punya banyak judul yang sedang ditonton, sudah selesai, atau masih menumpuk di daftar tunggu. Drama Vault membantu mencatat semuanya di satu tempat: sampai episode berapa, berapa lama sudah menonton, nilai tiap season, dan tema (trope) yang menjadi daya tarik drama tersebut.

**Fitur yang sudah diimplementasikan**

- Daftar drama dengan pencarian berdasarkan judul.
- Filter berdasarkan status tontonan: All, Watching, Finished, dan Backlog.
- Filter berdasarkan trope, misalnya Enemies-to-Lovers atau CEO Male Lead. Bisa digabung dengan pencarian dan filter status.
- Ringkasan total waktu menonton seluruh koleksi di layar utama.
- Tampilan daftar di HP dan tampilan grid di layar lebar (600 dp ke atas).
- Layar detail drama: progres episode beserta sisa episode, total waktu menonton, daftar trope, dan rating per season.
- Menambah drama baru lewat form dengan validasi input.
- Mengubah drama yang sudah ada dari layar detail.
- Tampilan kosong (empty state) dengan tombol Reset filters.
- Judul panjang ditangani: dipotong dengan elipsis di kartu, dan ditampilkan penuh di layar detail.
- Tema Material 3 terpusat, dengan mode terang dan mode gelap, serta font Montserrat.

**Batasan saat ini**

- Data hanya disimpan di memori, jadi kembali ke data awal saat aplikasi ditutup.

**Layar dan navigasi**

Aplikasi punya tiga layar. Semua perpindahan memakai push, sehingga tombol back selalu kembali ke layar sebelumnya.

- Home ke Detail: ketuk kartu drama.
- Home ke Form tambah: tombol plus.
- Detail ke Form ubah: ikon pensil di app bar.
- Form kembali ke layar pemanggil setelah disimpan atau dibatalkan. Setelah disimpan, Detail dan Home langsung menampilkan data terbaru.

**Home**

[Home](docs/screenshots/home.png)

Tampilan kosong, mode gelap, dan tablet:

[Home kosong](docs/screenshots/home-empty.png)
[Home mode gelap](docs/screenshots/home-dark.png)
[Home tablet](docs/screenshots/home-tablet.png)

**Detail**

[Detail](docs/screenshots/detail.png)

**Form**

[Form tambah](docs/screenshots/form-add.png)
[Form dengan pesan validasi](docs/screenshots/form-error.png)
[Form ubah](docs/screenshots/form-edit.png)

**Cara menjalankan**

Kebutuhan: Flutter SDK versi stabil, dan Chrome atau perangkat Android.

```
git clone https://github.com/etjandinegara-coder/Visual-Programming-EvelynTjandinegara-2086022510001.git
cd Visual-Programming-EvelynTjandinegara-2086022510001
flutter pub get
flutter run
```

Pilih perangkat yang tersedia, misalnya Chrome atau emulator Android.

Pemeriksaan kode:

```
flutter analyze
flutter test
```

**Harness uji perangkat**

Untuk menguji tampilan di berbagai ukuran layar, orientasi, keyboard, notch, dan mode gelap, jalankan:

```
flutter run -t tool/lab_harness.dart -d chrome
```

Harness ini bukan bagian dari aplikasi, sehingga disimpan di folder tool.

**Release APK**

Unduh APK dari halaman Releases di repositori ini dan jalankan:

```
flutter build apk --release
```

Hasilnya ada di build/app/outputs/flutter-apk/app-release.apk.

Atau: https://github.com/etjandinegara-coder/Visual-Programming-EvelynTjandinegara-2086022510001/releases/tag/v1.0.0

**Struktur proyek**

Proyek memakai pola layer-first: kode dikelompokkan berdasarkan jenis isi file.

```
lib/
  main.dart
  core/       fungsi bantu yang dipakai bersama
  design/     warna dan tema
  models/     Drama dan WatchStatus
  data/       data awal
  screens/    Home, Detail, Form
  widgets/    potongan UI
tool/         harness uji perangkat
test/         tes widget
docs/         dokumentasi
```

**Dokumentasi lain**

- [docs/structure.md](docs/structure.md): rincian struktur direktori dan pemisahan kode.
- [docs/week05/reflection.md](docs/week05/reflection.md): refleksi pengerjaan.
- [docs/week04/constraints.md](docs/week04/constraints.md): latihan diagnosis constraint dan overflow.