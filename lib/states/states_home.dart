// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_curved.dart';
import 'package:checkinapp/utility/app_service.dart';
import 'package:checkinapp/widgets/widget_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

final user = FirebaseAuth.instance.currentUser;

class HomeState extends State<Home> {
  List factorys = [];
  List original = [];
  Color bg = kPrimaryColor;
  int checkbg = 0;
  int typeRoleid = 1;
  TextEditingController txtQuery = TextEditingController();
  AppController controller = Get.put(AppController());
  Map<MarkerId, Marker> mapMarkers = {};

  Future<void> readInfoFactory() async {
    if (controller.factoryModels.isNotEmpty) {
      controller.factoryModels.clear();
    }
    await AppService().readUserModel();
    await FirebaseFirestore.instance
        .collection('checkin')
        // .where('typeid',isEqualTo: controller.userModels[0].typeworkid) //controller.userModels.last.typeworkid
        // .orderBy('id')
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
    loadData();
  }

  void loadData()  {
    // String jsonStr = await rootBundle.loadString('assets/factorys.json');
    // var json = jsonDecode(jsonStr);
    factorys = controller.factoryModels;
    original = controller.factoryModels;
    // setState(() {});
    aboutPositionAndMarker();
    addMarkerFactory();
   
  }

  void addMarkerFactory() {
    for (var i = 0; i < controller.factoryModels.length; i++) {
      MarkerId markerId = MarkerId('Factory $i');
      Marker marker = AppService().createMarker(
        latLng: LatLng(
            controller.factoryModels[i].position.latitude,
            controller.factoryModels[i].position
                .longitude), //controller.factoryModels[i].lat, controller.factoryModels[i].lng
        markerId: markerId,
        title: controller.factoryModels[i].title,
        subtitle: controller.factoryModels[i].subtitle,
      );
      mapMarkers[markerId] = marker;
    }
  }

  void aboutPositionAndMarker() {
    AppService().processFindPosition(context: context).then((value) {
      MarkerId markerId = const MarkerId('idUser');
      Marker marker = AppService().createMarker(
          latLng: LatLng(controller.position.last.latitude,
              controller.position.last.longitude),
          markerId: markerId,
          title: 'คุณอยู่ที่นี่',
          subtitle: 'You Here',
          hue: 0);

      mapMarkers[markerId] = marker;
    });
  }

  @override
  void initState() {
    super.initState();
    readInfoFactory();
    loadData();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              width: double.infinity,
              child: GetX(
                  init: AppController(),
                  builder: (AppController appController) {
                    print('## fac lat --> ${appController.factoryModels.length}');
                    return appController.position.isEmpty
                        ? const SizedBox()
                        :WidgetMap(
                            latLng: LatLng(appController.position.last.latitude,
                                appController.position.last.longitude),
                            mapMarkers: mapMarkers,
                          );
                  }),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CurvedWidget(
              child: Container(
                padding: const EdgeInsets.only(top: 60, left: 50),
                width: double.infinity,
                height: 250,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8A2387),
                      Color(0xFFE94057),
                      Color(0xFFF27121),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello,',
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    const Text(
                      'Welcome to Check-in app',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Name: ${controller.userModels.last.name}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Email: ${controller.userModels.last.email}  ',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
