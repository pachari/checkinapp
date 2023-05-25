// ignore_for_file: avoid_print

import 'package:checkinapp/widgets/widget_barbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                      height: 10,
                    ),
                    // const Text(
                    //   "Hello",
                    //   style:
                    //       TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(
                      height: 100,
                      width: 300,
                      child: LottieBuilder.asset(
                          "assets/lottie/144705-a-boat-on-the-river.json"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Please Login to Your Account",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetForm(
                            marginTop: 10,
                            hint: 'Email Address',
                            textEditingController: emailController,
                            iconController: const Icon(
                                FontAwesomeIcons.envelope,
                                color: kTrushColor),
                            obscureTextController: false),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetForm(
                            marginTop: 12,
                            hint: 'Password',
                            textEditingController: passwordController,
                            iconController: const Icon(
                                FontAwesomeIcons.eyeSlash,
                                color: kTrushColor),
                            obscureTextController: true),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       TextButton(
                    //         onPressed: click,
                    //         child: const Text(
                    //           "Forget Password",
                    //           style: TextStyle(color: Colors.deepOrange),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF8A2387),
                                  Color(0xFFE94057),
                                  Color(0xFFF27121),
                                ])),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
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
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    // const Text("Or Login using Social Media Account",
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold
                    //   ),),
                    // const SizedBox(height: 15,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     IconButton(
                    //         onPressed: click,
                    //         icon: const Icon(FontAwesomeIcons.facebook,color: Colors.blue)
                    //     ),
                    //     IconButton(
                    //         onPressed: click,
                    //         icon: const Icon(FontAwesomeIcons.google,color: Colors.redAccent,)
                    //     ),
                    //     IconButton(
                    //         onPressed: click,
                    //         icon: const Icon(FontAwesomeIcons.twitter,color: Colors.orangeAccent,)
                    //     ),
                    //     IconButton(
                    //         onPressed: click,
                    //         icon: const Icon(FontAwesomeIcons.linkedinIn,color: Colors.green,)
                    //     )
                    //   ],
                    // )
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${error.message}'),
          ),
        );
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
    var user = FirebaseAuth.instance.currentUser;
    // Firebase user = await _auth.currentUser;
    if (user != null) {
      print("Already singed-in with");
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const WidgetBarItem(currentPage:0,)));
      });
    }
  }
}
