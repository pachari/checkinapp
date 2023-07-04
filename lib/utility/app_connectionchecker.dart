// ignore_for_file: avoid_print

import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:checkinapp/models/user_model.dart';
// import 'package:checkinapp/componants/constants.dart';
// import 'package:checkinapp/models/user_model.dart';
import 'package:checkinapp/states/login_page.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_dialog.dart';
import 'package:checkinapp/utility/app_networkconnectivity.dart';
import 'package:checkinapp/utility/app_service.dart';
// import 'package:checkinapp/utility/app_service.dart';
import 'package:checkinapp/widgets/widget_barbutton.dart';
import 'package:checkinapp/widgets/widget_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';

class ConnectionCheckerDemo extends StatefulWidget {
  const ConnectionCheckerDemo({Key? key}) : super(key: key);
  @override
  State<ConnectionCheckerDemo> createState() => _ConnectionCheckerDemoState();
}

class _ConnectionCheckerDemoState extends State<ConnectionCheckerDemo> {
  AppController controller = Get.put(AppController());
  // String initRoute = '/loginapp';
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  // bool isAlertSet = false;
  @override
  void initState() {
    super.initState();
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string =
              _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }
      checkinternet(context);
      // 2.
      setState(() {});
      // 3.
      // AppSnackBar(title: 'Login Failure', massage: string).errorSnackBar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Image.asset("assets/icons/icon.png", width: 120)),
        const SizedBox(
          height: 20,
        ),
        Center(
            child: Image.asset("assets/images/98891-insider-loading.gif",
                width: 100)),
      ],
    ));
  }

  @override
  void dispose() {
    _networkConnectivity.disposeStream();
    super.dispose();
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // await checkinternet(context);
                //Off Service
                AppDialog(context: context).normalDialog(
                    title:
                        'No Connection Please check your internet connectivity',
                    content: 'Warning!',
                    firstAction: WidgetButton(
                      label: 'Open Setting',
                      pressFunc: () {
                        AppSettings.openWIFISettings();
                        exit(0);
                      },
                    ));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  Future<void> checkinternet(BuildContext context) async {
    if (_source.keys.toList()[0] == ConnectivityResult.none) {
      showDialogBox();
    } else {
      if (controller.userModels.isEmpty) {
        // // await Firebase.initializeApp().then((value) async {
        FirebaseAuth.instance.authStateChanges().listen((event) async {
          if (event != null) {
            //       //login
            await FirebaseFirestore.instance
                .collection('user')
                .doc(event.uid)
                // .where('uid', isEqualTo: event.uid)
                .get()
                .then((value) async {
              Map<String, dynamic> data = value.data() as Map<String, dynamic>;
              var array = data['todo']; // array is now List<dynamic>
              List<String> strings = List<String>.from(array);
              UserModel userModel = UserModel(
                email: data['email'],
                name: data['name'],
                role: data['role'],
                todo: strings,
                uid: data['uid'],
                typeworkid: data['typeid'],
              );
              controller.userModels.add(userModel);
              await AppService().readInfoFactoryAll();
              //เช็คว่าวันไหนมีการบันทึกรายการบ้าง
              await AppService().readCalendarallEventModel2(userModel.uid,DateTime.now());

              switch (controller.userModels.last.role) {
                case 'admin':
                  Get.offAll(() => const WidgetBarItem(currentPage: 0, roleUser: 'admin'));
                  break;
                case 'maid':
                  Get.offAll(() =>
                      const WidgetBarItem(currentPage: 0, roleUser: 'maid'));
                  break;
                case 'security':
                  Get.offAll(() => const WidgetBarItem(
                      currentPage: 0, roleUser: 'security'));
                  break;
                default:
                  Get.offAll(() => const LoginApp());
                  break;
              }
            });
          } else {
            Get.offAll(() => const LoginApp());
          }
        });
      } else {
        switch (controller.userModels.last.role) {
          case 'admin':
            Get.offAll(
                () => const WidgetBarItem(currentPage: 0, roleUser: 'admin'));
            break;
          case 'maid':
            Get.offAll(
                () => const WidgetBarItem(currentPage: 0, roleUser: 'maid'));
            break;
          case 'security':
            Get.offAll(() =>
                const WidgetBarItem(currentPage: 0, roleUser: 'security'));
            break;
          default:
            Get.offAll(() => const LoginApp());
            break;
        }
      }
    }
  }
}

// class NetworkConnectivity {
//   NetworkConnectivity._();
//   static final _instance = NetworkConnectivity._();
//   static NetworkConnectivity get instance => _instance;
//   final _networkConnectivity = Connectivity();
//   final _controller = StreamController.broadcast();
//   Stream get myStream => _controller.stream;
//   void initialise() async {
//     ConnectivityResult result = await _networkConnectivity.checkConnectivity();
//     _checkStatus(result);
//     _networkConnectivity.onConnectivityChanged.listen((result) {
//       print(result);
//       _checkStatus(result);
//     });
//   }

//   void _checkStatus(ConnectivityResult result) async {
//     bool isOnline = false;
//     try {
//       final result = await InternetAddress.lookup('example.com');
//       isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } on SocketException catch (_) {
//       isOnline = false;
//     }
//     _controller.sink.add({result: isOnline});
//   }

//   void disposeStream() => _controller.close();
// }
