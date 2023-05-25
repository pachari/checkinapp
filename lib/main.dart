// import 'package:checkinapp/states/authen.dart';
// import 'package:checkinapp/states/loginapp.dart';
import 'package:checkinapp/states/states_authen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M-Maid',
        theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: const CheckUserState(),//const Authen(),
    );
  }
}
