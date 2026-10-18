import 'package:flutter/material.dart';

class TropeFilter extends StatelessWidget {
  const TropeFilter({
    super.key,
    required this.tropes,
    required this.selectedTrope,
    required this.onTropeSelected,
  });

  final List<String> tropes;

  /// null berarti semua trope (tanpa filter).
  final String? selectedTrope;
  final ValueChanged<String?> onTropeSelected;

  @override
  Widget build(BuildContext context) {
    if (tropes.isEmpty) return const SizedBox.shrink();

    final selected = selectedTrope?.toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trope', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All tropes'),
                showCheckmark: false,
                selected: selected == null,
                onSelected: (_) => onTropeSelected(null),
              ),
              for (final trope in tropes) ...[
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text(trope),
                  showCheckmark: false,
                  selected: selected == trope.toLowerCase(),
                  onSelected: (_) => onTropeSelected(trope),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}