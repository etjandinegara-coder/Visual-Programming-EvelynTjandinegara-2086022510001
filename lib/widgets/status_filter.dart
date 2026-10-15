import 'package:flutter/material.dart';
import 'package:composition_md/models/drama.dart';

class StatusFilter extends StatelessWidget {
  const StatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  // null berarti "All" (tanpa filter).
  final WatchStatus? selectedStatus;
  final ValueChanged<WatchStatus?> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
              label: const Text('All'),
              showCheckmark: false,
              selected: selectedStatus == null,
              onSelected: (_) => onStatusSelected(null),
        ),
        for (final status in WatchStatus.values)
          ChoiceChip(
            label: Text(status.label),
            showCheckmark: false,
            selected: selectedStatus == status,
            onSelected: (_) => onStatusSelected(status),
          ),
      ],
    );
  }
}
