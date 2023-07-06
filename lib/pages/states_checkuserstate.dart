import 'package:checkinapp/pages/login_page.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/widgets/widget_barbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckUserState extends StatefulWidget {
  const CheckUserState({super.key});

  @override
  State<CheckUserState> createState() => _CheckUserStateState();
}

class _CheckUserStateState extends State<CheckUserState> {
  AppController controller = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  WidgetBarItem(
            currentPage: 0,
            roleUser:controller.userModels.last.role
          );
        } else {
          return const LoginAndSignup();
        }
      },
    );
  }
}
