import 'package:flutter/material.dart';
import 'package:composition_md/core/duration_format.dart';

class WatchTimeSummary extends StatelessWidget {
  const WatchTimeSummary({
    super.key,
    required this.totalMinutes,
    required this.dramaCount,
  });

  final int totalMinutes;
  final int dramaCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.schedule, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total watch time', style: theme.textTheme.bodySmall),
                  Text(
                    formatMinutes(totalMinutes),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Text(
              '$dramaCount ${dramaCount == 1 ? 'drama' : 'dramas'}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}