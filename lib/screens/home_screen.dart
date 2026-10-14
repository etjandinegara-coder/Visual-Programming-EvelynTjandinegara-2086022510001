import 'package:flutter/material.dart';

import 'package:composition_md/widgets/vault_header.dart';
import 'package:composition_md/widgets/drama_search_bar.dart';
import 'package:composition_md/widgets/status_filter.dart';
import 'package:composition_md/widgets/drama_list.dart';

/// Di lebar >= 600 dp, koleksi drama berubah dari list menjadi grid.
const double kTabletBreakpoint = 600;

/// Data bawaan app. Harness (lib/lab_harness.dart) bisa menggantinya
/// lewat parameter [HomeScreen.dramas] untuk keperluan tes.
const List<Map<String, dynamic>> kDefaultDramas = [
  {
    'title': 'Queen of Tears',
    'status': 'Watching',
    'genre': 'Romance',
    'rating': 9.2,
  },
  {
    'title': 'Lovely Runner',
    'status': 'Backlog',
    'genre': 'Romance',
    'rating': 9.5,
  },
  {
    'title': 'Colony',
    'status': 'Finished',
    'genre': 'Horror',
    'rating': 7.5,
  },
  {
    'title': 'Our Sticky Love',
    'status': 'Watching',
    'genre': 'Romance Comedy',
    'rating': 8.5,
  },
  {
    'title': 'Perfect Crown',
    'status': 'Finished',
    'genre': 'Romance Comedy',
    'rating': 8.8,
  },
  {
    'title': 'Alchemy of Souls',
    'status': 'Backlog',
    'genre': 'Fantasy',
    'rating': 9.7,
  },
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.dramas});

  /// null = pakai [kDefaultDramas].
  final List<Map<String, dynamic>>? dramas;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  String selectedStatus = 'All';
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> get dramas => widget.dramas ?? kDefaultDramas;

  List<Map<String, dynamic>> get filteredDramas {
    return dramas.where((drama) {
      final matchesSearch = drama['title']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesStatus =
          selectedStatus == 'All' || drama['status'] == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void resetFilters() {
    searchController.clear();
    setState(() {
      searchQuery = '';
      selectedStatus = 'All';
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Drama Vault',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      // SafeArea (tanpa top) supaya konten tidak tertutup notch saat landscape
      // dan tidak ada yang bisa diketuk di bawah gesture bar.
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTabletLayout = constraints.maxWidth >= kTabletBreakpoint;

            return CustomScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
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
                      onChanged: (value) =>
                          setState(() => searchQuery = value),
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
        ),
      ),
    );
  }
}