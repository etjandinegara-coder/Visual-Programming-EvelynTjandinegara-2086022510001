import 'package:flutter/material.dart';

class DramaCard extends StatelessWidget {
  final String title;
  final String status;
  final String genre;
  final double rating;

  const DramaCard({
    super.key,
    required this.title,
    required this.status,
    required this.genre,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('$genre • $status',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
            const SizedBox(width: 4),
            Text(rating.toStringAsFixed(1)),
          ],
        ),
      ),
    );
  }
}