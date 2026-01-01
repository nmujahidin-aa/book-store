import 'package:flutter/material.dart';

enum ToastType { success, error }

class AppToast {
  static void show(BuildContext context, String message, ToastType type) {
    final width = MediaQuery.sizeOf(context).width * 0.9;
    final bg = type == ToastType.success ? Colors.green : Colors.red;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bg,
        margin: EdgeInsets.only(
          left: (MediaQuery.sizeOf(context).width - width) / 2,
          right: (MediaQuery.sizeOf(context).width - width) / 2,
          bottom: 16,
        ),
        content: Text(message),
      ),
    );
  }
}