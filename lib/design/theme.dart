import 'package:flutter/material.dart';
import 'colors.dart';

TextTheme _buildDramaTextTheme(TextTheme base, {required bool isLight}) {
  return base
      .copyWith(
    headlineSmall: base.headlineSmall!.copyWith(
      fontWeight: FontWeight.w700,
    ),
    titleLarge: base.titleLarge!.copyWith(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
    ),
    bodySmall: base.bodySmall!.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    bodyLarge: base.bodyLarge!.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
    ),
  )
      .apply(
    fontFamily: 'Montserrat',
    // Brown 900 hanya untuk light mode. Di dark mode warna ini hampir tidak terbaca di atas background gelap, jadi pakai warna default.
    displayColor: isLight ? kDramaBrown900 : null,
    bodyColor: isLight ? kDramaBrown900 : null,
  );
}

ThemeData _buildDramaTheme(Brightness brightness) {
  final isLight = brightness == Brightness.light;
  final base = ThemeData(brightness: brightness, useMaterial3: true);

  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: isLight ? kDramaPink100 : null,
      foregroundColor: isLight ? kDramaBrown900 : null,
      scrolledUnderElevation: 0,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: kDramaPink400,
      brightness: brightness,
    ),
    textTheme: _buildDramaTextTheme(base.textTheme, isLight: isLight),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          // null di dark mode akan otomatis pakai warna primary
          color: isLight ? kDramaBrown900 : kDramaPink100,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: isLight ? kDramaBrown900 : kDramaPink100,
      ),
    ),
  );
}

final ThemeData dramaTheme = _buildDramaTheme(Brightness.light);
final ThemeData dramaDarkTheme = _buildDramaTheme(Brightness.dark);