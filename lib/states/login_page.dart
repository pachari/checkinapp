// ignore_for_file: avoid_print

import 'package:checkinapp/states/singin_page.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_service.dart';
import 'package:checkinapp/widgets/widget_barbutton.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/utility/app_snackbar.dart';
import 'package:checkinapp/widgets/widget_form.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user = FirebaseAuth.instance.currentUser;
  bool _passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String role = '';
  String uid = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                kPrimaryColor,
                kPrimaryColor,
                // Colors.red,
                // Colors.amber,
                // Colors.purpleAccent,
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 170, //100
              ),
              Container(
                width: 325,
                height: 400,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "CHECK-IN",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    // SizedBox(
                    //   height: 100,
                    //   width: 300,
                    //   child: LottieBuilder.asset(
                    //       "assets/lottie/144705-a-boat-on-the-river.json"),
                    // ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Please Login to Your Account",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetForm(
                            marginTop: 10,
                            hint: 'Your email',
                            textEditingController: emailController,
                            // iconController: const Icon( FontAwesomeIcons.envelope, color: kTrushColor),
                            iconController: IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.envelope,
                                  color: kTrushColor,
                                  size: 20,
                                ),
                                onPressed: () {}),
                            obscureTextController: false),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetForm(
                            marginTop: 10,
                            hint: 'Your password',
                            textEditingController: passwordController,
                            // iconController: const Icon( FontAwesomeIcons.eyeSlash, color: kTrushColor),
                            iconController: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.eye,
                                color: kTrushColor,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            obscureTextController: _passwordVisible),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildButtonLogin(),
                    buildOtherLine(),
                    const SizedBox(
                      height: 5,
                    ),
                    buildButtonRegister(),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    try {
      user = await _auth
          .signInWithEmailAndPassword(
        email: emailController.text.trim(), //"pachari_pm@hotmail.com",
        password: passwordController.text.trim(), //"123456", //
      )
          .then((user) {
        print("signed in ${user.user}");
        checkAuth(context); // add here
      }).catchError((error) {
        print(error.message);
        AppSnackBar(title: 'Login Failure', massage: '${error.message}')
            .errorSnackBar();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('${error.message}'),
        //   ),
        // );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future checkAuth(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    await AppService().readUserModel();
    AppController controller = Get.put(AppController());
    if (user != null &&
        controller.userModels.last.role == 'admin' &&
        controller.userModels.last.uid == user.uid) {
      print("Already singed-in with Admin ");
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Get.offAll(WidgetBarItem(
        //     currentPage: 0, roleUser: controller.userModels.last.role));
        Get.offAll(() => WidgetBarItem(
            currentPage: 0, roleUser: controller.userModels.last.role));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => const WidgetBarItem( currentPage: 0)));
      });
    } else {
      print("Already singed-in with User ");
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => WidgetBarItem(
            currentPage: 0, roleUser: controller.userModels.last.role));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => const WidgetBarItem(
        //               currentPage: 0,
        //             )));
      });
    }
  }

  Widget buildOtherLine() {
    return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Row(children: <Widget>[
          Expanded(child: Divider(color: Colors.green[800])),
          const Padding(
              padding: EdgeInsets.all(6),
              child: Text("Don’t have an account?",
                  style: TextStyle(color: Colors.black87))),
          Expanded(child: Divider(color: Colors.green[800])),
        ]));
  }

  GestureDetector buildButtonRegister() {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        width: 280,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.red[400]),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Sign up',
            style: TextStyle(color: Colors.white, fontSize: kDefaultFont),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SingInApp()),
        );
      },
    );
  }

  GestureDetector buildButtonLogin() {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        width: 280,
        decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(kDefaultCircular)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  kPrimaryColor.withOpacity(0.8),
                  kPrimaryColor.withOpacity(0.8),
                  // Color(0xFF8A2387),
                  // Color(0xFFE94057),
                  // Color(0xFFF27121),
                ])),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: kDefaultFont),
          ),
        ),
      ),
      onTap: () {
        if ((emailController.text.isEmpty) ||
            (passwordController.text.isEmpty)) {
          AppSnackBar(
                  title: 'Login Failure',
                  massage: 'Please Check Email or Password.')
              .errorSnackBar();
        } else {
          signIn();
        }
      },
    );
  }
}
