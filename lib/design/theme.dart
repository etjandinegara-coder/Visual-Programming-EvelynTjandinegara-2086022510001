import 'package:flutter/material.dart';
import 'colors.dart';

TextTheme _buildDramaTextTheme(TextTheme base) {
  return base
      .copyWith(
    headlineSmall: base.headlineSmall!.copyWith(
      fontWeight: FontWeight.w500,
    ),
    titleLarge: base.titleLarge!.copyWith(
      fontSize: 18.0,
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
    fontFamily: 'Rubik',
    displayColor: kDramaBrown900,
    bodyColor: kDramaBrown900,
  );
}

final ThemeData dramaTheme = ThemeData(
  useMaterial3: true,

  colorScheme: ColorScheme.fromSeed(
    seedColor: kDramaPink400,
  ),

  textTheme: _buildDramaTextTheme(
    ThemeData.light().textTheme,
  ),

  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2.0,
        color: kDramaBrown900,
      ),
    ),
    floatingLabelStyle: TextStyle(
      color: kDramaBrown900,
    ),
  ),
);