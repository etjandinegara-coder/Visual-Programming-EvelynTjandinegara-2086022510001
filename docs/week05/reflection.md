**Refleksi Week 5**

1. Which structural decision from Week 1 helped you most by Week 5?

Tugas dari Week 1 sangat membantu mulai dari menyusun layar dari widget kecil yang masing-masing punya satu tugas, dan menyimpan state di satu tempat saja. Di H1 kita memecah layar utama menjadi VaultHeader, DramaSearchBar, StatusFilter, DramaList, dan DramaCard, masing-masing di file sendiri. Widget-widget itu tidak menyimpan state. Kata pencarian dan status terpilih berada di HomeScreen, sedangkan widget anak hanya menerima nilai dan callback lewat parameter.

Hal itu memudahkan proses pengerjaan hingga ke week 5 ini. Tampilan grid di layar lebar pada Week 4 cukup mengubah DramaList. Mengganti Map dengan model Drama hanya mengubah isi file-file kecil itu, bukan seluruh layar. Ketukan kartu hanya butuh satu callback yang diteruskan dari DramaList ke DramaCard. Filter trope dan ringkasan total waktu menonton masuk sebagai dua widget baru ke susunan yang sudah ada, tanpa membongkar widget lama. Kalau semuanya masih satu method build yang panjang, setiap perubahan itu akan jauh lebih berisiko.

2. Which one cost you time, and what would you do differently?

Yang paling memakan waktu adalah menunda model data. Sampai Week 5, satu drama masih berupa Map dengan kunci teks, dan status ditulis sebagai teks bebas. Ketika Track A menuntut progres episode, rating per season, trope, dan waktu menonton, Map itu tidak lagi cukup, jadi saya menggantinya dengan kelas Drama dan enum WatchStatus. Perubahannya menyebar ke HomeScreen, DramaList, DramaCard, StatusFilter, dan harness uji. Selama sebagian file sudah diubah dan sebagian belum, flutter analyze melaporkan 17 masalah sekaligus. Butuh waktu untuk menyadari bahwa penyebab sebenarnya hanya beberapa edit yang tertinggal, misalnya sisa tipe lama di satu baris dan blok data lama yang belum dihapus.

Kalau mengulang, saya akan membuat model Drama dan menentukan konvensi folder pada minggu pertama atau kedua, sebelum widget menerima parameter lepas. Model yang dibuat di awal murah, sedangkan model yang dibuat di akhir harus mengubah semua yang sudah bergantung pada Map. Saya juga akan menjaga file harness tetap kecil sejak awal. File itu tumbuh sampai 440 baris, dan memecahnya menjadi beberapa file adalah pekerjaan tambahan yang bisa dihindari.

3. Where is your app's state right now, and what will be hard about moving it in Module 2?

Saat ini state tersebar di beberapa tempat dan semuanya hidup di dalam widget.

Daftar drama disimpan di State milik HomeScreen. Daftar drama disalin dari kDefaultDramas di initState, lalu ditambah atau diubah langsung di tempat. State filter, yaitu kata pencarian, status terpilih, dan trope terpilih, juga berada di HomeScreen. DramaDetailScreen menyimpan salinan drama miliknya sendiri dan memberi tahu Home lewat callback ketika drama diedit. Form menyimpan isiannya di controller dan mengembalikan hasilnya lewat Navigator.pop. Tidak ada penyimpanan, jadi semua perubahan hilang saat aplikasi ditutup.

Hal yang akan sulit dipindahkan di Module 2:

1. Satu drama ada di dua tempat. Daftar di Home dan salinan di Detail harus disinkronkan lewat callback. Dengan sumber data bersama, Detail seharusnya membaca drama berdasarkan id, bukan menyimpan salinan, dan itu mengubah cara layar tersebut dibangun.
2. Aturan data berada di dalam widget. Contohnya, setelah drama diedit, HomeScreen sendiri yang menghapus filter trope yang sudah tidak ada. Aturan seperti ini harus pindah ke objek pengelola state, dan tes widget yang sekarang menjalankan HomeScreen langsung harus diubah mengikutinya.
3. Daftar diubah di tempat, lewat penambahan dan penggantian pada indeks. Drama sendiri immutable dan punya copyWith, tapi list-nya tidak, dan Drama belum punya perbandingan kesamaan lewat operator sama dengan dan hashCode. Banyak solusi state management memutuskan kapan harus membangun ulang dengan membandingkan nilai lama dan baru, jadi mutasi di tempat dan ketiadaan kesamaan nilai bisa menimbulkan bug yang sulit terlihat.
4. Semua operasi saat ini sinkron. Data tersedia seketika di initState, sehingga aplikasi belum punya keadaan memuat dan gagal yang sungguhan. Begitu data datang dari repository atau penyimpanan, kedua keadaan itu harus ditambahkan ke setiap layar yang menampilkan data.
5. Id dibuat dari waktu saat ini di form. Id seharusnya diberikan oleh penyimpanan.

Langkah pertama yang akan saya ambil: membuat repository di folder data yang menggantikan kDefaultDramas sebagai satu-satunya sumber, lalu satu objek pengelola yang memegang daftar drama dan dipakai bersama oleh Home dan Detail. State filter tetap menjadi state tampilan di Home karena tidak perlu disimpan. Tes widget yang ada akan diberi repository palsu supaya tetap berjalan.