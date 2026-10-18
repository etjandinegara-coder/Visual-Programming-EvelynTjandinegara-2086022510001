import 'package:flutter/material.dart';

import 'package:composition_md/screens/drama_detail_screen.dart';
import 'package:composition_md/widgets/watch_time_summary.dart';
import 'package:composition_md/screens/drama_form_screen.dart';
import 'package:composition_md/widgets/drama_search_bar.dart';
import 'package:composition_md/widgets/status_filter.dart';
import 'package:composition_md/widgets/vault_header.dart';
import 'package:composition_md/widgets/trope_filter.dart';
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
  String _searchQuery = '';
  WatchStatus? _selectedStatus;
  String? _selectedTrope;
  final TextEditingController _searchController = TextEditingController();

  late List<Drama> _dramas;

  @override
  void initState() {
    super.initState();
    _dramas = List.of(widget.dramas ?? kDefaultDramas);
  }

  List<Drama> get _filteredDramas => _dramas.filtered(
    query: _searchQuery,
    status: _selectedStatus,
    trope: _selectedTrope,
  );

  void _openDetail(Drama drama) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DramaDetailScreen(
          drama: drama,
          onUpdated: _updateDrama,
        ),
      ),
    );
  }

  Future<void> _addDrama() async {
    final created = await Navigator.of(context).push<Drama>(
      MaterialPageRoute(builder: (_) => const DramaFormScreen()),
    );
    if (!mounted || created == null) return;
    setState(() => _dramas.add(created));
  }

  void _updateDrama(Drama updated) {
    setState(() {
      final index = _dramas.indexWhere((d) => d.id == updated.id);
      if (index != -1) _dramas[index] = updated;
      // Trope yang dipilih bisa hilang setelah drama diedit.
      final trope = _selectedTrope;
      if (trope != null && !_dramas.containsTrope(trope)) {
        _selectedTrope = null;
      }
    });
  }

  Widget _box(double top, Widget child, {double bottom = 0}) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16, top, 16, bottom),
      sliver: SliverToBoxAdapter(child: child),
    );
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedStatus = null;
      _selectedTrope = null;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
        onPressed: _addDrama,
        tooltip: 'Add drama',
        child: const Icon(Icons.add),
      ),
      // SafeArea (tanpa top) supaya konten tidak tertutup notch saat landscape
      // dan tidak ada yang bisa diketuk di bawah gesture bar.
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= kTabletBreakpoint;

            return CustomScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                _box(16, const VaultHeader()),
                _box(
                  16,
                  WatchTimeSummary(
                    totalMinutes: _dramas.totalWatchedMinutes,
                    dramaCount: _dramas.length,
                  ),
                ),
                _box(
                  16,
                  DramaSearchBar(
                    controller: _searchController,
                    onChanged: (value) =>
                        setState(() => _searchQuery = value),
                  ),
                ),
                _box(
                  16,
                  StatusFilter(
                    selectedStatus: _selectedStatus,
                    onStatusSelected: (status) =>
                        setState(() => _selectedStatus = status),
                  ),
                ),
                _box(
                  8,
                  TropeFilter(
                    tropes: _dramas.allTropes,
                    selectedTrope: _selectedTrope,
                    onTropeSelected: (trope) =>
                        setState(() => _selectedTrope = trope),
                  ),
                ),
                _box(
                  24,
                  Text(
                    'My Watchlist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  bottom: 8,
                ),
                DramaList(
                  dramas: _filteredDramas,
                  isTablet: isTablet,
                  onReset: _resetFilters,
                  onDramaTap: _openDetail,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}