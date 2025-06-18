import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart';

class MessageHelper {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBarMessage({isSuccess = bool, message = String}) {
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor:
            isSuccess ? AppColors.primaryColorGreen : AppColors.primaryColorRed,
        padding: const EdgeInsets.all(18),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            backgroundColor:
                isSuccess
                    ? AppColors.primaryColorGreen
                    : AppColors.primaryColorRed,
            color: AppColors.backgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  static void showTopSnackBar({
    required BuildContext context,
    required String message,
    required bool isSuccess,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color:
                      isSuccess
                          ? AppColors.primaryColorGreen
                          : AppColors.primaryColorRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(
      const Duration(seconds: 3),
    ).then((_) => overlayEntry.remove());
  }
}
