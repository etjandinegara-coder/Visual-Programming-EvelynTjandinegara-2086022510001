import 'package:flutter/material.dart';

class DramaSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const DramaSearchBar({
    super.key,
    required this.onChanged, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 1,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        hintText: 'Search drama...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }
}