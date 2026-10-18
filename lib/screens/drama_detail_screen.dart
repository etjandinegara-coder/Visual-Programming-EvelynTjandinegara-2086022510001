import 'package:flutter/material.dart';
import 'package:composition_md/models/drama.dart';
import 'package:composition_md/screens/drama_form_screen.dart';

class DramaDetailScreen extends StatefulWidget {
  const DramaDetailScreen({super.key, required this.drama, required this.onUpdated});

  final Drama drama;
  final ValueChanged<Drama> onUpdated;

  @override
  State<DramaDetailScreen> createState() => _DramaDetailScreenState();
}

class _DramaDetailScreenState extends State<DramaDetailScreen> {
  late Drama _drama = widget.drama;

  Future<void> _edit() async {
    final updated = await Navigator.of(context).push<Drama>(
      MaterialPageRoute(builder: (_) => DramaFormScreen(drama: _drama)),
    );
    if (!mounted || updated == null) return;
    setState(() => _drama = updated);
    widget.onUpdated(updated);
  }


  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final drama = _drama;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Drama Detail'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit drama',
              onPressed: _edit,
            ),
          ],
        ),
        body: SafeArea(
            top: false,
            child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(drama.title, style: text.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  '${drama.genre} • ${drama.status.label}',
                  style: text.bodyLarge,
                ),
                const SizedBox(height: 24),
                _Section(
                  title: 'Progress',
                  child: _ProgressBlock(drama: drama),
                ),
                _Section(
                  title: 'Watch time',
                  child: Text(
                    _formatMinutes(drama.watchedMinutes),
                    style: text.bodyLarge,
                  ),
                ),
                _Section(
                  title: 'Tropes',
                  child: drama.tropes.isEmpty
                      ? Text('No tropes added yet.', style: text.bodySmall)
                      : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final trope in drama.tropes)
                        Chip(label: Text(trope)),
                    ],
                  ),
                ),
                _Section(
                  title: 'Season ratings',
                  child: _SeasonRatings(ratings: drama.seasonRatings),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _ProgressBlock extends StatelessWidget {
  const _ProgressBlock({required this.drama});

  final Drama drama;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${drama.watchedEpisodes} / ${drama.totalEpisodes} episodes',
          style: text.bodyLarge,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: drama.progress),
        const SizedBox(height: 8),
        Text('${drama.episodesLeft} episodes left', style: text.bodySmall),
      ],
    );
  }
}

class _SeasonRatings extends StatelessWidget {
  const _SeasonRatings({required this.ratings});

  final List<double> ratings;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    if (ratings.isEmpty) {
      return Text('No ratings yet.', style: text.bodySmall);
    }

    return Column(
      children: [
        for (var i = 0; i < ratings.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text('Season ${i + 1}', style: text.bodyLarge),
                ),
                Icon(
                  Icons.star_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(ratings[i].toStringAsFixed(1), style: text.bodyLarge),
              ],
            ),
          ),
      ],
    );
  }
}

String _formatMinutes(int minutes) {
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  if (hours == 0) return '$rest min';
  if (rest == 0) return '$hours h';
  return '$hours h $rest min';
}