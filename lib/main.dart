import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:composition_md/design/colors.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kDramaPink400,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}