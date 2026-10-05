import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:composition_md/design/colors.dart';
import 'package:composition_md/design/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drama Vault',
      theme: dramaTheme,
      home: const HomeScreen(),
    );
  }
}