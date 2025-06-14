
import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart';


class MessageHelper {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBarMessage({isSuccess = bool, message = String}) {
    scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: isSuccess ? AppColors.primaryColorGreen : AppColors.primaryColorRed,
      padding: const EdgeInsets.all(18),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          backgroundColor: isSuccess ?  AppColors.primaryColorGreen : AppColors.primaryColorRed,
          color: AppColors.backgroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }
}