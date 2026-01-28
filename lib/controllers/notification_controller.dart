import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NotificationController extends GetxController {
  // Use GetX snackbar for notifications to maintain a cross-platform, Flutter-centric approach
  // and avoid complex native Android/iOS setup for local notifications.

  void showNotification({
    required String title,
    required String message,
    bool isError = false,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? AppColors.error : AppColors.primary,
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      icon: Icon(
        isError ? Icons.error_outline : Icons.notifications_none_rounded,
        color: Colors.white,
      ),
    );
  }

  void showVoiceFeedback(String text) {
    Get.snackbar(
      "Vox AI",
      text,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.darkSurface.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
