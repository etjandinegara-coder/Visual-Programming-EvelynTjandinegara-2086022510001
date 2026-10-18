import 'package:flutter/material.dart';
import 'package:composition_md/models/drama.dart';

class DramaCard extends StatelessWidget {
  const DramaCard({super.key, required this.drama, this.onTap});

  final Drama drama;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(drama.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('${drama.genre} • ${drama.status.label}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(drama.averageRating.toStringAsFixed(1)),
          ],
        ),
      ),
    );
  }
}