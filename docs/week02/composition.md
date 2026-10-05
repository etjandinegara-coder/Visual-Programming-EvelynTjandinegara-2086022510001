1. VaultHeader
- The Trigger = readability (untuk menampilkan header)
- It owns = judul dan subtitle ditampilkan dibagian atas
- Reports upward = tidak ada, hanya bertugas menampilkan informasi

2. DramaSearchBar
- The Trigger = readability (bagian pencarian)
- It owns = kolom pencarian dan ikon pencarian
- Reports upward = melaporkan kata yang dicari oleh pengguna melalui callback 'onChanged'

3. StatusFilter
- The Trigger = readability (bagian pilihan filter status) 
- It owns = pilihan status 'All' , 'Watching' , 'Finished' , 'Backlog'
- Reports upward = melaporkan status yang di pilih pengguna melalui callback 'onStatusSelected'

4. DramaList
- The Trigger = readability (menampilkan daftar drama)
- It owns = daftar drama yang sudah difilter dan menampilkan pesan kalau ada drama yang tidak ditemukan
- Reports upward = tidak ada, hanya bertugas menerima data dari parent lalu menampilkannya

5. DramaCard
- The Trigger = reuse (struktur card yang sama digunakan berulang kali untuk setiap drama dalam daftar)
- It owns = menampilkan judul drama, genre, status dan rating
- Reports upward = tidak ada, hanya bertugas menampilkan data yang diberikan oleh parent
