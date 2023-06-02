import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/utility/app_snackbar.dart';
import 'package:checkinapp/widgets/widget_form.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:lottie/lottie.dart';

class SingInApp extends StatefulWidget {
  const SingInApp({super.key});

  @override
  State<SingInApp> createState() => _SingInAppState();
}

class _SingInAppState extends State<SingInApp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String? dropdownTypeValue = 'Maid';

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
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              Container(
                width: 325,
                // height: 700,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "SingIn",
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
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetForm(
                            marginTop: 10,
                            hint: 'Email Address',
                            textEditingController: emailController,
                             iconController: IconButton(
                                icon: const Icon(FontAwesomeIcons.envelope,
                                    color: kTrushColor),
                                onPressed: () {}),
                            // iconController: const Icon(
                            //     FontAwesomeIcons.envelope,
                            //     color: kTrushColor),
                            obscureTextController: false),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetForm(
                            marginTop: 10,
                            hint: 'Email Address',
                            textEditingController: emailController,
                            // iconController: const Icon( FontAwesomeIcons.envelope, color: kTrushColor),
                            iconController: IconButton(
                                icon: const Icon(FontAwesomeIcons.envelope,
                                    color: kTrushColor),
                                onPressed: () {}),
                            obscureTextController: false),
                      ],
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetForm(
                            marginTop: 10,
                            hint: 'Confirm-password',
                            textEditingController: confirmpasswordController,
                            // iconController: const Icon( FontAwesomeIcons.envelope, color: kTrushColor),
                            iconController: IconButton(
                                icon: const Icon(FontAwesomeIcons.envelope,
                                    color: kTrushColor),
                                onPressed: () {}),
                            obscureTextController: false),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WidgetForm(
                            marginTop: 20,
                            hint: 'Username',
                            textEditingController: usernameController,
                            iconController: IconButton(
                                icon: const Icon(FontAwesomeIcons.user,
                                    color: kTrushColor),
                                onPressed: () {}),
                            // iconController: const Icon(FontAwesomeIcons.user,
                            //     color: kTrushColor),
                            obscureTextController: false),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          iconSize: 30,
                          elevation: 24,
                          dropdownColor: kTextColor.withOpacity(0.6),
                          alignment: Alignment.topCenter,
                          value: dropdownTypeValue,
                          items: <String>['Security guard', 'Maid']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownTypeValue = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
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
                            'SingIn',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () {
                        if ((emailController.text.isEmpty) ||
                            (passwordController.text.isEmpty) ||
                            (usernameController.text.isEmpty)) {
                          AppSnackBar(
                                  title: 'SingIn Failure',
                                  massage: 'Please Fill in Data ')
                              .errorSnackBar();
                        } else if (passwordController.text !=
                                confirmpasswordController.text &&
                            usernameController.text.length >= 6) {
                          AppSnackBar(
                                  title: 'SingIn Failure',
                                  massage:
                                      'Please Check Password and Confirm-password is not match.')
                              .errorSnackBar();
                        } else {
                          // Register();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Please Fill in data to Create Account",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 17,
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

  // Future<void> Register() async {
  //   // print(emailController.text.trim());
  //   // print(passwordController.text.trim());
  //   // print(usernameController.text.trim());
  //   // print(dropdownTypeValue);

  //   // print('Result');

  //   // print(usernameController.text.length);

  //   // if (passwordController == ConfirmpasswordController && passwordController >= 6) {
  //   //   _auth
  //   //       .createUserWithEmailAndPassword(email: email, password: password)
  //   //       .then((user) {
  //   //     print("Sign up user successful.");
  //   //   }).catchError((error) {
  //   //     print(error.message);
  //   //   });
  //   // } else {
  //   //   print("Password and Confirm-password is not match.");
  //   // }

  //   // await FirebaseAuth.instance
  //   //     .signInWithEmailAndPassword(
  //   //         email: "panuwat.developer@gmail.com", password: "123456")
  //   //     .then((user) {
  //   //   print("signed in ${user.email}");
  //   // }).catchError((error) {
  //   //   print(error);
  //   // });
  // }
}
