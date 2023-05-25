import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  final String title;
  final String massage;
  AppSnackBar({
    required this.title,
    required this.massage,
  });

  void errorSnackBar() {
    Get.snackbar(title, massage,backgroundColor: const Color.fromARGB(255, 255, 46, 46),colorText: Colors.white);
  }

  void normalSnackBar() {
    Get.snackbar(title, massage);
  }
}
