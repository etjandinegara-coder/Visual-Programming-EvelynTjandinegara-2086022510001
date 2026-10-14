**H2 — Constraint Diagnosis**

Tiga overflow sengaja dibuat di kode Drama Vault, lalu diperbaiki. Urutan tiap kasus: file yang dirusak, kode yang salah, error yang muncul, aturan constraint yang dilanggar (satu kalimat), lalu kode perbaikannya.

**Aturan dasar Flutter**

Constraints go down, sizes go up, parent sets position.

Parent memberi constraint (lebar dan tinggi minimum/maksimum) ke child. Child memilih ukuran di dalam constraint itu, lalu melaporkannya ke atas.

Row dan Column memberi child mereka constraint tak terbatas di sumbu utamanya (Row: lebar, Column: tinggi). Child tidak dipaksa muat. Kalau total ukuran child lebih besar dari ruang yang tersedia, Flutter melaporkan RenderFlex overflowed.


**A. Row + Text panjang (overflow horizontal)**

File: lib/widgets/drama_card.dart

Kode yang salah: DramaCard dibuat dengan Row manual, tanpa Expanded:

```dart
@override
Widget build(BuildContext context) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text('$genre • $status',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
              const SizedBox(width: 4),
              Text(rating.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    ),
  );
}
```

Setting harness: Small phone + Portrait + Data 200-char title.

Error Message:

```
══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════
The following assertion was thrown during layout:
A RenderFlex overflowed by 1325 pixels on the right.
```

Perhatikan bahwa maxLines: 1 dan overflow: ellipsis sudah dipasang di Text, tapi tetap overflow. Ellipsis hanya bekerja kalau Text mendapat lebar yang terbatas, sedangkan Row memberi Column lebar tak terbatas.

Aturan yang dilanggar:

Row memberi child non-flex constraint lebar tak terbatas, jadi Column berisi Text panjang mengambil lebar penuh teksnya dan melewati batas layar, karena tidak ada Expanded atau Flexible yang memberinya batas.

Perbaikan:

Bungkus Column dengan Expanded. Sekarang Row menghitung dulu lebar widget rating, lalu memberikan sisa lebarnya ke Column. Karena lebarnya terbatas, ellipsis mulai bekerja:

```dart
@override
Widget build(BuildContext context) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('$genre • $status',
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
              const SizedBox(width: 4),
              Text(rating.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    ),
  );
}
```

Alternatif: kembali memakai ListTile, yang menangani hal ini di dalamnya (title dan subtitle otomatis mendapat lebar sisa setelah trailing diukur).


**B. Column lebih tinggi dari layar (overflow vertikal)**

File: lib/screens/home_screen.dart

Kode yang salah : CustomScrollView diganti dengan Column biasa, dan DramaList diganti deretan DramaCard. Tambahkan import 'package:composition_md/widgets/drama_card.dart'; di bagian atas file, lalu ganti isi builder pada LayoutBuilder:

```dart
builder: (context, constraints) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VaultHeader(),
        const SizedBox(height: 20),
        DramaSearchBar(
          controller: searchController,
          onChanged: (value) => setState(() => searchQuery = value),
        ),
        const SizedBox(height: 16),
        StatusFilter(
          selectedStatus: selectedStatus,
          onStatusSelected: (status) =>
              setState(() => selectedStatus = status),
        ),
        const SizedBox(height: 20),
        const Text('My Watchlist'),
        for (final d in filteredDramas)
          DramaCard(
            title: d['title'] as String,
            status: d['status'] as String,
            genre: d['genre'] as String,
            rating: (d['rating'] as num).toDouble(),
          ),
      ],
    ),
  );
},
```

Setting harness: Small phone + Landscape + Data Normal.

Error Message:

```
══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════
The following assertion was thrown during layout:
A RenderFlex overflowed by 418 pixels on the bottom.
```

Aturan yang dilanggar:

Column memberi child constraint tinggi tak terbatas, tapi dirinya sendiri dibatasi tinggi body Scaffold, sehingga total tinggi child (header + search + filter + 6 kartu) melebihi tinggi yang tersedia dan Column tidak bisa scroll.

Perbaikan:

Ganti Column dengan CustomScrollView dan pecah isinya menjadi sliver. Scroll view boleh punya isi lebih tinggi dari layar karena ia memberi child ruang tak terbatas dan mengatur sendiri bagian mana yang terlihat. DramaList (SliverList.builder untuk HP, SliverGrid.builder untuk tablet) hanya membangun kartu yang sedang tampil. Import DramaCard tidak diperlukan lagi di file ini, jadi hapus.

```dart
builder: (context, constraints) {
  final isTabletLayout = constraints.maxWidth >= kTabletBreakpoint;

  return CustomScrollView(
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    slivers: [
      const SliverPadding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        sliver: SliverToBoxAdapter(child: VaultHeader()),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        sliver: SliverToBoxAdapter(
          child: DramaSearchBar(
            controller: searchController,
            onChanged: (value) => setState(() => searchQuery = value),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        sliver: SliverToBoxAdapter(
          child: StatusFilter(
            selectedStatus: selectedStatus,
            onStatusSelected: (status) =>
                setState(() => selectedStatus = status),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        sliver: SliverToBoxAdapter(
          child: Text(
            'My Watchlist',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
      ),
      DramaList(
        dramas: filteredDramas,
        isTablet: isTabletLayout,
        onReset: resetFilters,
      ),
    ],
  );
},
```

Kenapa bukan SingleChildScrollView(child: Column(...)): cara itu juga menghilangkan overflow, tapi semua kartu dibangun sekaligus. Dengan Data 500 items, 500 kartu langsung dibuat walaupun hanya beberapa yang terlihat. Dengan sliver, hanya yang terlihat yang dibangun. Cara itu juga tidak bisa dipakai untuk layout grid di tablet.


**C. Child Row dengan lebar tetap yang totalnya melebihi layar**

File: lib/widgets/status_filter.dart

Kode yang salah : Wrap diganti Row, dan tiap chip diberi lebar tetap:

```dart
@override
Widget build(BuildContext context) {
  return Row(
    children: statuses.map((status) {
      return SizedBox(
        width: 110,
        child: ChoiceChip(
          label: Text(status),
          showCheckmark: false,
          selected: selectedStatus == status,
          onSelected: (_) => onStatusSelected(status),
        ),
      );
    }).toList(),
  );
}
```

Setting harness: Large phone + Portrait + Data Normal.

Error Message:

```
══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════
The following assertion was thrown during layout:
A RenderFlex overflowed by 42 pixels on the right.

The relevant error-causing widget was:
Row
```

Aturan yang dilanggar:

Child dengan ukuran tetap tidak bisa menyusut mengikuti constraint, jadi Row yang total lebar child-nya (440 dp) lebih besar dari lebar maksimum yang diberikan parent (398 dp) pasti overflow dan tidak pernah pindah baris.

Perbaikan:

Pakai Wrap dan biarkan tiap chip memakai lebar alaminya. Wrap membaca lebar maksimum dari parent, lalu memindahkan chip yang tidak muat ke baris berikutnya:

```dart
@override
Widget build(BuildContext context) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: statuses.map((status) {
      return ChoiceChip(
        label: Text(status),
        showCheckmark: false,
        selected: selectedStatus == status,
        onSelected: (_) => onStatusSelected(status),
      );
    }).toList(),
  );
}
```

Alternatif kalau ingin tetap satu baris yang bisa digeser: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(...)).


Ringkasan

| Kasus | File | Sumbu | Penyebab | Perbaikan |
|---|---|---|---|---|
| A | drama_card.dart | kanan | Row memberi lebar tak terbatas ke Column, tanpa Expanded | Bungkus Column dengan Expanded |
| B | home_screen.dart | bawah | Column berisi lebih banyak dari tinggi layar, tidak bisa scroll | CustomScrollView dengan sliver |
| C | status_filter.dart | kanan | Lebar tetap 4 x 110 dp lebih besar dari lebar layar | Wrap |

Intinya: setiap overflow berarti ada widget yang meminta ruang lebih besar daripada yang bisa diberikan parent-nya. Pertanyaan diagnosisnya selalu sama: siapa parent-nya, constraint apa yang dia berikan di sumbu itu, dan siapa yang tidak mau mengalah?