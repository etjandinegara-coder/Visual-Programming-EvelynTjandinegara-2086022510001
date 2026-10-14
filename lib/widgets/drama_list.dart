import 'package:flutter/material.dart';

import 'drama_card.dart';

class DramaList extends StatelessWidget {
  final List<Map<String, dynamic>> dramas;
  final bool isTablet;
  final VoidCallback onReset;

  const DramaList({
    super.key,
    required this.dramas, required this.isTablet, required this.onReset,
  });

  Widget _buildCard(int index) {
    final drama = dramas[index];
    return DramaCard(
      title: drama['title'] as String,
      status: drama['status'] as String,
      genre: drama['genre'] as String,
      rating: (drama['rating'] as num).toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (dramas.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(onReset: onReset),
      );
    }

    const padding = EdgeInsets.fromLTRB(16, 0, 16, 24);

    if (isTablet) {
      return SliverPadding(
        padding: padding,
        sliver: SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 420,
            mainAxisExtent: 96,
            crossAxisSpacing: 8,
          ),
          itemCount: dramas.length,
          itemBuilder: (context, index) => _buildCard(index),
        ),
      );
    }

    return SliverPadding(
      padding: padding,
      sliver: SliverList.builder(
        itemCount: dramas.length,
        itemBuilder: (context, index) => _buildCard(index),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onReset;

  const _EmptyState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.movie_filter_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No drama found',
              textAlign: TextAlign.center,
              maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search or clear the filters.',
              textAlign: TextAlign.center,
              maxLines: 3, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset filters'),
            ),
          ],
        ),
      ),
    );
  }
}