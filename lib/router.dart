

// import 'package:checkinapp/states/states_authen.dart';
import 'package:checkinapp/states/states_singin.dart';
import 'package:checkinapp/states/states_login.dart';
import 'package:checkinapp/widgets/widget_barbutton.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> map = {
  '/authen' : (BuildContext context) => const LoginApp(),  //const CheckUserState(), //
  '/singup' : (BuildContext context) => const SingInApp(), 
  '/serviceAdmin' : (BuildContext context) =>  const WidgetBarItem(currentPage: 0, roleUser: 'admin'),
  '/serviceMaid' : (BuildContext context) =>  const WidgetBarItem(currentPage: 0, roleUser: 'maid'),
  '/serviceSecurity' : (BuildContext context) =>  const WidgetBarItem(currentPage: 0, roleUser: 'security'),

};