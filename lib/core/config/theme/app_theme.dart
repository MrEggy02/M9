import 'app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  
  // ຮູບແບບ theme ຫຼັກຂອງແອັບ
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    fontFamily: "NotoSansLao",
    appBarTheme: const AppBarTheme(
      color: AppColors.backgroundColor,
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
  );
}