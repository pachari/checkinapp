// ignore_for_file: avoid_function_literals_in_foreach_calls, use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';
import 'dart:math';

import 'package:checkinapp/models/checktodoresult_model.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/models/todoresult_model.dart';
import 'package:checkinapp/models/user_model.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_dialog.dart';
import 'package:checkinapp/widgets/widget_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppService {
  AppController appController = Get.put(AppController());
  final db = FirebaseFirestore.instance;
  final db_todo = FirebaseFirestore.instance.collection('todolist');
  final _auth = FirebaseAuth.instance.currentUser;

  Future<void> readInfoFactory() async {
    await db.collection('checkin').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        appController.factoryModels.add(FactoryModel(
            position: doc["position"],
            qr: doc["qr"],
            subtitle: doc["subtitle"],
            title: doc["title"],
            typeid: doc["typeid"]));
      });
    });
  }

  Future<void> readUserModel() async {
    await db.collection("user").doc(_auth!.uid).get().then((value) {
      UserModel userModel = UserModel.fromMap(value.data()!);
      appController.userModels.add(userModel);
    });
  }

  Future<void> CheckTodoResultModel(int eventid, String datadate) async {
    List<String> resultdocid = [];
    //Check type from page / 0 = calendar / >0 = todolist_state
    if (eventid == 0) {
      //  เป็นการ insert collection ต่อท้ายของตัว Checkin int eventid,
      // await db_todo
      //     .doc("id$eventid")
      //     .collection("todo")
      //     .doc(datadate)
      //     .get()
      //     .then((value) {
      //   appController.checktodoresultModels.clear();
      //   if (value.data() == null) {
      //     CheckTodoResultModels checktodoresultModels =
      //         CheckTodoResultModels(result: (0));
      //     appController.checktodoresultModels.add(checktodoresultModels);
      //   } else {
      //     CheckTodoResultModels checktodoresultModels =
      //         CheckTodoResultModels(result: (1));
      //     appController.checktodoresultModels.add(checktodoresultModels);
      //   }
      // });

      // เป็นการ insert collection แยก ไม่ต่อท้ายตัวไหน ขึ้นใหม่เลย
      await db_todo
          .doc(_auth?.uid)
          .collection(datadate)
          // .doc("checkinid$eventid")
          .get()
          .then((value) {
        value.docs.forEach((doc) {
          resultdocid.add(doc.id);
        });
        appController.checktodoresultModels.clear();
        if (value.docs.isEmpty) {
          CheckTodoResultModels checktodoresultModels =
              CheckTodoResultModels(result: (0), resultcheckinid: resultdocid);
          appController.checktodoresultModels.add(checktodoresultModels);
        } else {
          CheckTodoResultModels checktodoresultModels =
              CheckTodoResultModels(result: (1), resultcheckinid: resultdocid);
          appController.checktodoresultModels.add(checktodoresultModels);
        }
      });
    } else {
      // เป็นการ insert collection แยก ไม่ต่อท้ายตัวไหน ขึ้นใหม่เลย
      await db_todo
          .doc(_auth?.uid)
          .collection(datadate)
          .doc("id$eventid")
          .get()
          .then((value) {
        appController.checktodoresultModels.clear();
        if (value.data() == null) {
          CheckTodoResultModels checktodoresultModels =
              CheckTodoResultModels(result: (0), resultcheckinid: resultdocid);
          appController.checktodoresultModels.add(checktodoresultModels);
        } else {
          CheckTodoResultModels checktodoresultModels =
              CheckTodoResultModels(result: (1), resultcheckinid: resultdocid);
          appController.checktodoresultModels.add(checktodoresultModels);
        }
      });
    }
  }

  Future<void> readTodoResultModel(String eventid, String datadate) async {
    // var formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
    List<bool> finishtodos = [];
    //  เป็นการ insert collection ต่อท้ายของตัว Checkin
    // await db
    //     .collection('checkin')
    //     .doc("id$eventid")
    //     .collection("todo")
    //     .doc(datadate)
    //     .get()
    //     .then((value) {
    // int insertId = 1;
    await db_todo
        .doc(_auth?.uid)
        .collection(datadate)
        .doc(eventid)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data() as Map<String, dynamic>;
      for (var i = 0; i < data['finishtodo'].length; i++) {
        if (data['finishtodo'][i] == true) {
          finishtodos.add(true);
        } else {
          finishtodos.add(false);
        }
      }
      TodoResultModels todoresultModels = TodoResultModels(
          uidCheck: data['uidCheck'],
          timestampIn: data['timestampIn'],
          timestampOut: data['timestampOut'],
          finishtodo: finishtodos,
          checkinid: data['checkinid']);
      appController.todoresultModels.add(todoresultModels);
    });
  }

  double calculateDistance(
      double lat2, double lng2, RxList<Position> position) {
    double distance = 0.0;
    if (position.isNotEmpty) {
      double lat1 = appController.position.last.latitude;
      double lng1 = appController.position.last.longitude;

      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
      distance = 12742 * asin(sqrt(a));
      distance = distance * 1000;
    }
    return distance; //unit km to m
  }

  Marker createMarker(
      {required LatLng latLng,
      required MarkerId markerId,
      required String title,
      required String subtitle,
      double? hue}) {
    Marker marker = Marker(
        markerId: markerId,
        position: latLng,
        infoWindow: InfoWindow(title: title, snippet: subtitle),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue ?? 120));

    return marker;
  }

  Future<void> processFindPosition({required BuildContext context}) async {
    bool locationServiceEnable = await Geolocator.isLocationServiceEnabled();
    LocationPermission locationPermission;
    Position positions;

    if (locationServiceEnable) {
      //Open Service
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.deniedForever) {
        //ไม่อนุญาต
        PermissionDialog(context);
      } else {
        //Deny , Allow , One in use
        if (locationPermission == LocationPermission.denied) {
          //ยังไม่รู้ว่าอนุญาตไหม
          locationPermission = await Geolocator.requestPermission();
          if ((locationPermission != LocationPermission.whileInUse) &&
              (locationPermission != LocationPermission.always)) {
            // =Deny
            PermissionDialog(context);
          } else {
            positions = await Geolocator.getCurrentPosition();
            appController.position.add(positions);
          }
        } else {
          positions = await Geolocator.getCurrentPosition();
          appController.position.add(positions);
        }
      }
    } else {
      //Off Service
      AppDialog(context: context).normalDialog(
          title: 'Off Location',
          content: 'Warning!',
          firstAction: WidgetButton(
            label: 'Open Location',
            pressFunc: () {
              Geolocator.openLocationSettings();
              exit(0);
            },
          ));
    }
  }

  void PermissionDialog(BuildContext context) {
    AppDialog(context: context).normalDialog(
        title: 'Permission Location',
        content: 'Warning!',
        firstAction: WidgetButton(
          label: 'Permission',
          pressFunc: () {
            Geolocator.openAppSettings();
            exit(0);
          },
        ));
  }
}
