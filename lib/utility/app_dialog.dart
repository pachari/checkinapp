import 'package:checkinapp/widgets/widget_button.dart';
// import 'package:checkinapp/widgets/widget_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  final BuildContext context;
  AppDialog({
    required this.context,
  });

  void normalDialog({required String title, required String content, Widget? firstAction}) {
    Get.dialog(
      AlertDialog(
        title: Text(content),
        content: Text( title),
        actions: [
          firstAction ??
              WidgetButton(
                label: 'OK',
                pressFunc: () {
                  Get.back();
                },
              )
        ],
      ),
    );
  }
}
