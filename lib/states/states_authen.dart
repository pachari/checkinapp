import 'package:checkinapp/states/states_login.dart';
import 'package:checkinapp/widgets/widget_barbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckUserState extends StatelessWidget {
  const CheckUserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const WidgetBarItem(
            currentPage: 0,
          );
        } else {
          return const LoginApp();
        }
      },
    );
  }
}
