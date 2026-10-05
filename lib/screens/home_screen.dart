import 'package:flutter/material.dart';

import 'package:composition_md/widgets/vault_header.dart';
import 'package:composition_md/widgets/drama_search_bar.dart';
import 'package:composition_md/widgets/status_filter.dart';
import 'package:composition_md/widgets/drama_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  String selectedStatus = 'All';

  final List<Map<String, dynamic>> dramas = [
    {
      'title': 'Queen of Tears',
      'status': 'Watching',
      'genre': 'Romance',
      'rating': 9.2,
    },
    {
      'title': 'Lovely Runner',
      'status': 'Backlog',
      'genre': 'Romance',
      'rating': 9.5,
    },
    {
      'title': 'Colony',
      'status': 'Finished',
      'genre': 'Horor',
      'rating': 7.5,
    },
    {
      'title': 'Our Sticky Love',
      'status': 'Watching',
      'genre': 'Romance Comedy',
      'rating': 8.5,
    },
    {
      'title': 'Perfect Crown',
      'status': 'Finished',
      'genre': 'Romance Comedy',
      'rating': 8.8,
    },
    {
      'title': 'Alchemy of Souls',
      'status': 'Backlog',
      'genre': 'Fantasy',
      'rating': 9.7,
    },
  ];

  List<Map<String, dynamic>> get filteredDramas {
    return dramas.where((drama) {
      final matchesSearch = drama['title']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesStatus = selectedStatus == 'All' ||
          drama['status'] == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drama Vault'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VaultHeader(),

            const SizedBox(height: 20),

            DramaSearchBar(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 16),

            StatusFilter(
              selectedStatus: selectedStatus,
              onStatusSelected: (status) {
                setState(() {
                  selectedStatus = status;
                });
              },
            ),

            const SizedBox(height: 20),

            Text(
              'My Watchlist',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: DramaList(
                dramas: filteredDramas,
              ),
            ),
          ],
        ),
      ),
    );
  }
}