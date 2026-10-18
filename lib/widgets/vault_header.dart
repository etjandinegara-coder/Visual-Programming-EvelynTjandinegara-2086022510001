import 'package:flutter/material.dart';

class VaultHeader extends StatelessWidget {
  const VaultHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Drama Vault',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Track your favorite dramas',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge
        )
      ],
    );
  }
}