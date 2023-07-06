// ignore_for_file: use_build_context_synchronously

import 'package:checkinapp/componants/background_noimage.dart';
import 'package:checkinapp/componants/responsive.dart';
import 'package:checkinapp/pages/login_page.dart';
import 'package:checkinapp/pages/welcome_image.dart';
import 'package:checkinapp/utility/app_connectionchecker.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigationhome();
  }

  void _navigationhome() async {
    await Future.delayed(const Duration(microseconds: 1500), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ConnectionCheckerDemo(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return const BackgroundNoimage(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Responsive(
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: WelcomeImage(),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 450,
                        child: LoginAndSignup(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            mobile: MobileWelcomeScreen(),
          ),
        ),
      ),
    );
  }
}

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        WelcomeImage(),
        // Row(
        //   children:  [
        //     Spacer(),
        //     Expanded(
        //       flex: 8,
        //       child: LoginAndSignup(),
        //     ),
        //     Spacer(),
        //   ],
        // ),
      ],
    );
  }
}
