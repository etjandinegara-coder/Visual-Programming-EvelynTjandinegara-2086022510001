import 'package:flutter/material.dart';

class StatusFilter extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusSelected;

  const StatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  final List<String> statuses = const [
    'All',
    'Watching',
    'Finished',
    'Backlog',
  ];

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
}