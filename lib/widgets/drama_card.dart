import 'package:flutter/material.dart';
import 'package:composition_md/models/drama.dart';

class DramaCard extends StatelessWidget {
  const DramaCard({super.key, required this.drama});

  final Drama drama;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
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
            const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
            const SizedBox(width: 4),
            Text(drama.averageRating.toStringAsFixed(1)),
          ],
        ),
      ),
    );
  }
}