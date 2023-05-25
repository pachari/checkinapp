import 'package:checkinapp/utility/app_curved.dart';
import 'package:flutter/material.dart';
import 'package:checkinapp/utility/app_snackbar.dart';
import 'package:checkinapp/widgets/widget_button.dart';
import 'package:checkinapp/widgets/widget_form.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CurvedWidget(
            child: Container(
              padding: const EdgeInsets.only(top: 100, left: 50),
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 255, 0, 0),
                    const Color.fromARGB(255, 255, 149, 135).withOpacity(0.9)
                    // const Color.fromARGB(255, 4, 1, 202),
                    // const Color.fromARGB(255, 218, 225, 255).withOpacity(0.4)
                  ],
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(255, 19, 19, 19),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200, left: 20, right: 20),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    WidgetForm(
                        marginTop: 64,
                        hint: 'Email',
                        textEditingController: emailController,
                        iconController: const Icon(Icons.email), obscureTextController:false),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    WidgetForm(
                        hint: 'Password',
                        textEditingController: passwordController,
                        iconController: const Icon(Icons.lock), obscureTextController:true),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 350,
                      height: 45,
                      margin: const EdgeInsets.only(top: 16),
                      child: WidgetButton(
                        label: 'Login',
                        pressFunc: () {
                          if ((emailController.text.isEmpty) ||
                              (passwordController.text.isEmpty)) {
                            AppSnackBar(
                                    title: 'Login Failure',
                                    massage: 'Please Check Email or Password.')
                                .errorSnackBar();
                          } else {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const SecondRoute()),
                            // );
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
