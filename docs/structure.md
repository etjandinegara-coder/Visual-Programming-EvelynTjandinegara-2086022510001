**Struktur Proyek**

**Konvensi yang dipakai: layer-first**

Kode dikelompokkan berdasarkan jenis isi file, bukan berdasarkan fitur. Pertanyaan yang dipakai saat menaruh sebuah file adalah: file ini sebenarnya apa? Model masuk folder models, halaman penuh masuk screens, dan potongan UI masuk widgets.

Layer-first dipilih karena aplikasi ini kecil dan hanya punya satu domain, yaitu watchlist drama. Semua layar mengelola entitas yang sama, jadi memisahkan kode per fitur tidak menambah kejelasan. Satu konvensi ini dipakai di seluruh proyek.

**Pohon direktori**

```
lib/
  main.dart
  core/
    duration_format.dart
  design/
    colors.dart
    theme.dart
    fonts/                      aset font Montserrat
  models/
    drama.dart
  data/
    drama_data.dart
  screens/
    home_screen.dart
    drama_detail_screen.dart
    drama_form_screen.dart
  widgets/
    drama_card.dart
    drama_list.dart
    drama_search_bar.dart
    status_filter.dart
    trope_filter.dart
    vault_header.dart
    watch_time_summary.dart
tool/
  lab_harness.dart
  harness/
    harness_data.dart
    harness_panel.dart
    harness_stage.dart
    drama_test_app.dart
    fake_device.dart
test/
  widget_test.dart
docs/
  structure.md
  week04/
  week05/
```

**Tanggung jawab tiap folder**

| Folder | Isi | Alasan ditaruh di sini |
|---|---|---|
| main.dart | Titik masuk, MaterialApp, pemasangan tema | Hanya merakit aplikasi, tidak berisi logika layar |
| core | Fungsi bantu yang dipakai bersama, saat ini formatMinutes | Dipakai oleh layar Detail dan ringkasan di layar utama, dan tidak cocok di folder lain. Alasan lengkap ada di bagian Isi folder core |
| design | Warna, tema terang dan gelap, font | Semua keputusan tampilan ada di satu tempat. Kode fitur tidak menulis warna atau ukuran font sendiri, hanya membaca dari Theme.of(context) |
| models | Drama, WatchStatus, dan fungsi untuk koleksi drama (filter, trope, total waktu) | Bentuk data dan aturan datanya. Dart murni, tidak mengimpor Flutter, sehingga tidak bergantung pada UI |
| data | Daftar drama awal (kDefaultDramas) | Sumber data dipisahkan dari model dan layar, jadi nanti bisa diganti dengan penyimpanan sungguhan tanpa menyentuh layar |
| screens | Satu file per halaman penuh yang dibuka lewat Navigator | Layar mengatur state halaman dan navigasi. Widget privat yang hanya dipakai satu layar, misalnya _Section, tetap satu file dengan layarnya |
| widgets | Potongan UI yang dirakit menjadi halaman | Dipakai oleh layar dan tidak tahu cara bernavigasi. Menerima data dan callback lewat parameter |
| tool | Harness uji perangkat: ukuran layar, rotasi, keyboard, notch, mode gelap | Alat bantu pengembangan, bukan bagian aplikasi, jadi tidak masuk ke folder lib |
| test | Tes widget | Memeriksa perilaku layar (misalnya empty state dan overflow di lebar 320 dp) tanpa menjalankan aplikasi penuh. Mengikuti konvensi Flutter, folder ini berada di luar lib |
| docs | Dokumentasi dan bukti latihan per minggu | Dipisahkan dari kode |

**Arah dependensi**

```
main.dart  ->  design, screens

screens    ->  widgets, data, core, models
widgets    ->  models, core
data       ->  models
```

- Folder models dan core tidak mengimpor apa pun dari proyek ini.
- Folder data hanya bergantung pada models.
- Folder widgets bergantung pada models dan core.
- Folder screens boleh memakai widgets, data, core, dan models. Hanya screens yang memanggil Navigator.
- Folder design tidak mengimpor layer lain. Hanya main.dart yang memakainya untuk memasang tema, sedangkan layar dan widget membaca tema lewat Theme.of(context).

Aturan ini menjaga agar perubahan di satu layer tidak merambat ke layer lain.

**Isi folder core**

Folder core hanya untuk kode yang benar-benar dipakai bersama dan tidak punya rumah lain. Awalnya folder ini sengaja tidak dibuat, karena fungsi formatMinutes hanya dipakai satu layar dan cukup dibuat privat di file layar itu.

Setelah fitur total waktu menonton ditambahkan, fungsi yang sama dipakai di dua tempat yang berbeda: layar Detail (waktu per drama) dan ringkasan di layar utama (total koleksi). Fungsi itu bukan milik model, bukan widget, dan bukan bagian dari tema, jadi dipindahkan ke core/duration_format.dart.

Aturan yang dipakai: kode baru masuk core hanya jika dipakai minimal dua tempat berbeda dan tidak cocok di folder lain. Kalau hanya satu tempat, tetap privat di file itu.

**Penamaan dan kode**

- Nama file memakai snake_case dan sama dengan kelas utamanya. Contoh: DramaCard ada di drama_card.dart.
- Kelas dan enum memakai UpperCamelCase. Variabel, fungsi, dan parameter memakai lowerCamelCase.
- Konstanta global diawali huruf k lalu UpperCamelCase. Contoh: kDramaPink50 dan kDefaultDramas.
- Anggota privat diawali garis bawah, termasuk state di dalam kelas State.
- Semua impor di folder lib memakai bentuk package:composition_md. Tidak ada impor relatif. Di folder tool, antar file harness memakai impor relatif karena folder tool bukan bagian dari paket.