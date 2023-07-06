

// import 'package:checkinapp/states/states_authen.dart';
import 'package:checkinapp/splash.dart';
import 'package:checkinapp/pages/singin_page.dart';
import 'package:checkinapp/pages/login_page.dart';
import 'package:checkinapp/utility/app_connectionchecker.dart';
// import 'package:checkinapp/utility/app_connectionchecker.dart';
import 'package:checkinapp/widgets/widget_barbutton.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> map = {
  '/splashscreen' : (BuildContext context) => const SplashScreen(), 
  '/internet' : (BuildContext context) => const ConnectionCheckerDemo(), 
  '/loginapp' : (BuildContext context) => const LoginAndSignup(),  //const CheckUserState(), //
  '/singup' : (BuildContext context) => const SingInApp(), 
  '/serviceAdmin' : (BuildContext context) =>  const WidgetBarItem(currentPage: 0, roleUser: 'admin'),
  '/serviceMaid' : (BuildContext context) =>  const WidgetBarItem(currentPage: 0, roleUser: 'maid'),
  '/serviceSecurity' : (BuildContext context) =>  const WidgetBarItem(currentPage: 0, roleUser: 'security'),

};