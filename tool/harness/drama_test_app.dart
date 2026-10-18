import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:composition_md/design/theme.dart';
import 'package:composition_md/screens/home_screen.dart';
import 'package:composition_md/models/drama.dart';

class DramaTestApp extends StatelessWidget {
  const DramaTestApp({super.key, required this.dramas, required this.themeMode});

  final List<Drama> dramas;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drama Vault',
      debugShowCheckedModeBanner: false,
      theme: dramaTheme,
      darkTheme: dramaDarkTheme,
      themeMode: themeMode,
      // Supaya bisa drag dengan mouse di Chrome / desktop.
      scrollBehavior: const MaterialScrollBehavior()
          .copyWith(dragDevices: PointerDeviceKind.values.toSet()),
      home: HomeScreen(dramas: dramas),
    );
  }
}