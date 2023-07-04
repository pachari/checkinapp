// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'package:checkinapp/componants/background.dart';
import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/factory_model.dart';
// import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/utility/app_controller.dart';
// import 'package:checkinapp/utility/app_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:checkinapp/utility/app_curved.dart';
// import 'package:checkinapp/utility/app_service.dart';
// import 'package:checkinapp/widgets/widget_map.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

final user = FirebaseAuth.instance.currentUser;

class HomeState extends State<Home> {
  List factorys = [];
  List original = [];
  AppController controller = Get.put(AppController());
  Future<void> readInfoFactory() async {
    await FirebaseFirestore.instance
        .collection('checkin')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["typeid"] == controller.userModels[0].typeworkid) {
          controller.factoryModels.add(FactoryModel(
            position: doc["position"],
            qr: doc["qr"],
            subtitle: doc["subtitle"],
            title: doc["title"],
            typeid: doc["typeid"],
            id: doc["id"],
          ));
        }
      });
    });
  }

  void loadData() {
    // String jsonStr = await rootBundle.loadString('assets/factorys.json');
    // var json = jsonDecode(jsonStr);
    factorys = controller.factoryModels;
    original = controller.factoryModels;
  }

  @override
  void initState() {
    super.initState();
    readInfoFactory();
    // loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Stack(children: <Widget>[
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     SizedBox(
          //       height: MediaQuery.of(context).size.height / 1.3,
          //       width: double.infinity,
          //       child: GetX(
          //           init: AppController(),
          //           builder: (AppController appController) {
          //             print('## fac lat --> ${appController.factoryModels.length}');
          //             return appController.position.isEmpty
          //                 ? const SizedBox()
          //                 :WidgetMap(
          //                     latLng: LatLng(appController.position.last.latitude,
          //                         appController.position.last.longitude),
          //                     mapMarkers: mapMarkers,
          //                   );
          //           }),
          //     ),
          //   ],
          // ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     CurvedWidget(
          //       child: Container(
          //         padding: const EdgeInsets.only(top: 200, left: 50),
          //         width: double.infinity,
          //         height: 500,
          //         decoration: const BoxDecoration(
          //           gradient: LinearGradient(
          //             begin: Alignment.topLeft,
          //             end: Alignment.bottomRight,
          //             colors: [
          //               Color(0xFF8A2387),
          //               Color(0xFFE94057),
          //               Color(0xFFF27121),
          //             ],
          //           ),
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             const Text(
          //               'Hello,',
          //               style: TextStyle(
          //                   fontSize: 40,
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                   fontStyle: FontStyle.italic),
          //             ),
          //             const Text(
          //               'Welcome to Check-in app',
          //               style: TextStyle(
          //                   fontSize: 15,
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                   fontStyle: FontStyle.italic),
          //             ),
          //             const SizedBox(height: 100),
          //             Text(
          //               'Name: ${controller.userModels.last.name}',
          //               style: const TextStyle(
          //                 fontSize: 15,
          //                 color: Colors.white,
          //                 fontStyle: FontStyle.italic,
          //               ),
          //             ),
          //             const SizedBox(height: 2),
          //             Text(
          //               'Email: ${controller.userModels.last.email}  ',
          //               style: const TextStyle(
          //                 fontSize: 15,
          //                 color: Colors.white,
          //                 fontStyle: FontStyle.italic,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(alignment: AlignmentDirectional.topCenter, children: [
                SizedBox(
                  height: 200,
                  width: 300,
                  child: LottieBuilder.asset("assets/lottie/91732-hello.json"),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 100, bottom: 0, left: 20, right: 20),
                  child: Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 6,
                        child: SvgPicture.asset(
                          "assets/icons/chat.svg",
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ]),
              const Text(
                "WELCOME TO CHECK-IN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    controller.userModels.last.name,
                    style: const TextStyle(
                      fontSize: kDefaultFont,
                      // fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.userModels.last.email,
                    style: const TextStyle(
                      fontSize: kDefaultFont,
                      // fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 100),
            ],
          )
        ]),
      ),
    );
  }
}
