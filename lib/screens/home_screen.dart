import 'package:flutter/material.dart';

import 'package:composition_md/screens/drama_detail_screen.dart';
import 'package:composition_md/screens/drama_form_screen.dart';
import 'package:composition_md/widgets/drama_search_bar.dart';
import 'package:composition_md/widgets/status_filter.dart';
import 'package:composition_md/widgets/vault_header.dart';
import 'package:composition_md/widgets/drama_list.dart';
import 'package:composition_md/data/drama_data.dart';
import 'package:composition_md/models/drama.dart';


/// Di lebar >= 600 dp, koleksi drama berubah dari list menjadi grid.
const double kTabletBreakpoint = 600;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.dramas});

  final List<Drama>? dramas;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  WatchStatus? selectedStatus;
  final TextEditingController searchController = TextEditingController();

  late List<Drama> _dramas;

  @override
  void initState() {
    super.initState();
    _dramas = List.of(widget.dramas ?? kDefaultDramas);
  }

  List<Drama> get dramas => _dramas;

  List<Drama> get filteredDramas {
    final query = searchQuery.toLowerCase();
    return dramas.where((drama) {
      final matchesSearch = drama.title.toLowerCase().contains(query);
      final matchesStatus =
          selectedStatus == null || drama.status == selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  void openDetail(Drama drama) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DramaDetailScreen(
          drama: drama,
          onUpdated: updateDrama,
        ),
      ),
    );
  }

  Future<void> addDrama() async {
    final created = await Navigator.of(context).push<Drama>(
      MaterialPageRoute(builder: (_) => const DramaFormScreen()),
    );
    if (!mounted || created == null) return;
    setState(() => _dramas.add(created));
  }

  void updateDrama(Drama updated) {
    setState(() {
      final index = _dramas.indexWhere((d) => d.id == updated.id);
      if (index != -1) _dramas[index] = updated;
    });
  }

  void resetFilters() {
    searchController.clear();
    setState(() {
      searchQuery = '';
      selectedStatus = null;
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
      floatingActionButton: FloatingActionButton(
        onPressed: addDrama,
        tooltip: 'Add drama',
        child: const Icon(Icons.add),
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
                  onDramaTap: openDetail,
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