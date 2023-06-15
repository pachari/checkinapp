// ignore_for_file: avoid_function_literals_in_foreach_calls, use_build_context_synchronously, non_constant_identifier_names, avoid_print

import 'dart:io';
import 'dart:math';

import 'package:checkinapp/blocs/todo_list/todo_list_bloc.dart';
import 'package:checkinapp/models/calendarevent_model.dart';
import 'package:checkinapp/models/checktodoresult_model.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/models/fileupload_model.dart';
import 'package:checkinapp/models/todoresult_model.dart';
import 'package:checkinapp/models/user_model.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_dialog.dart';
import 'package:checkinapp/widgets/widget_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class AppService {
  AppController controller = Get.put(AppController());
  final _auth = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  final db_todo = FirebaseFirestore.instance.collection('todolist');

  Future<void> readFileUpload(String id,String datadate) async {
    controller.fileuploadModels.clear();
    await db_todo
        .doc(_auth?.uid)
        .collection(datadate) //DateFormat('yyyyMMdd').format(DateTime.now())
        .doc('id$id')
        .collection('fileupload')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        FileUploads fileuploadModels = FileUploads(
            name: value.docs.last['name'],
            remark: value.docs.last['remark'],
            image: value.docs.last['image'],
            uid: _auth!.uid,
            factoryid: id);
        controller.fileuploadModels.add(fileuploadModels);
      }
    });
  }

  Future<void> readInfoFactory(int id) async {
    // await db.collection('checkin').get().then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     controller.factoryModels.add(FactoryModel(
    //         position: doc["position"],
    //         qr: doc["qr"],
    //         subtitle: doc["subtitle"],
    //         title: doc["title"],
    //         typeid: doc["typeid"],
    //         id: doc["id"]));
    //   });
    // });
    await FirebaseFirestore.instance
        .collection('checkin')
        .where('id', isEqualTo: id) //controller.userModels.last.typeworkid
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        controller.factoryModels.add(FactoryModel(
          position: doc["position"],
          qr: doc["qr"],
          subtitle: doc["subtitle"],
          title: doc["title"],
          typeid: doc["typeid"],
          id: doc["id"],
        ));
      });
    });
  }

  Future<void> readUserModel() async {
    // before add role,email,uid,
    // await db.collection("user").doc(_auth!.uid)
    // .get().then((value) {
    //   UserModel userModel = UserModel.fromMap(value.data()!);
    //   appController.userModels.add(userModel);
    // });

    // After add role,email,uid,
    await db
        .collection('user')
        .where('email', isEqualTo: _auth!.email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        var array = value.docs[0]['todo']; // array is now List<dynamic>
        List<String> strings = List<String>.from(array);
        UserModel userModel = UserModel(
          email: value.docs[0]['email'],
          name: value.docs[0]['name'],
          role: value.docs[0]['role'],
          todo: strings,
          uid: value.docs[0]['uid'],
          typeworkid: value.docs[0]['typeid'],
        );
        controller.userModels.add(userModel);
      }
    });
  }

  Future<void> CheckTodoResultModel(int eventid, String datadate) async {
    List<String> resultdocid = [];
    // var formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
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
        controller.checktodoresultModels.clear();
        if (value.docs.isEmpty) {
          CheckTodoResultModels checktodoresultModels = CheckTodoResultModels(
              result: (0),
              resultcheckinid: resultdocid,
              collectiondate: datadate);
          controller.checktodoresultModels.add(checktodoresultModels);
        } else {
          CheckTodoResultModels checktodoresultModels = CheckTodoResultModels(
              result: (1),
              resultcheckinid: resultdocid,
              collectiondate: datadate);
          controller.checktodoresultModels.add(checktodoresultModels);
        }
      });
    } else {
      // เป็นการ insert collection แยก ไม่ต่อท้ายตัวไหน ขึ้นใหม่เลย
      await db_todo //.where('uidCheck', isEqualTo: _auth!.uid)
          .doc(_auth?.uid)
          .collection(datadate)
          .doc("id$eventid")
          .get()
          .then((value) {
        controller.checktodoresultModels.clear();
        if (value.data() == null) {
          CheckTodoResultModels checktodoresultModels = CheckTodoResultModels(
              result: (0),
              resultcheckinid: resultdocid,
              collectiondate: datadate);
          controller.checktodoresultModels.add(checktodoresultModels);
        } else {
          CheckTodoResultModels checktodoresultModels = CheckTodoResultModels(
              result: (1),
              resultcheckinid: resultdocid,
              collectiondate: datadate);
          controller.checktodoresultModels.add(checktodoresultModels);
        }
      });
    }
  }

  Future<void> readTodoResultModel(String eventid, String datadate) async {
    // var formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
    List<bool> finishtodos = [];
    // appController.todoresultModels.clear();
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
      if (value.data() != null) {
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
        controller.todoresultModels.add(todoresultModels);
      }
    });
  }

  Future<void> readCalendarallEventModel(String uid, int days) async {
    var formattedDate = DateFormat('yyyyMM').format(DateTime.now());
    List<String> finishtodos = [];
    String d = '';
    for (var i = 1; i <= days; i++) {
      if (i < 10) {
        d = '${formattedDate}0$i';
      } else {
        d = '$formattedDate$i';
      }
      await db_todo.doc(uid).collection(d).get().then(
        (querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            finishtodos.add(d);
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    }
    CalendarAllEvent calendaralleventModels = CalendarAllEvent(
        uidCheck: uid, dataDate: finishtodos, finishtodosid: []);
    controller.calendaralleventModels.add(calendaralleventModels);
  }

  Future<void> readCalendarallEventModel2(String uid) async {
    var formattedDate = DateFormat('yyyyMM').format(DateTime.now());
    List<String> finishtodos = [];
    List<String> finishtodosid = [];
    DateTime dataDate = DateTime(DateTime.now().year, DateTime.now().month, 0);
    DateTime dataDate2 =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    int inDays = dataDate2.difference(dataDate).inDays;
    String d = '';
    for (var i = 1; i <= inDays; i++) {
      if (i < 10) {
        d = '${formattedDate}0$i';
      } else {
        d = '$formattedDate$i';
      }
      // set data result date save
      await db_todo.doc(uid).collection(d).get().then(
        //.orderBy('checkinid')
        (querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            finishtodos.add(d);
            for (var x = 0; x < querySnapshot.docs.length; x++) {
              finishtodosid.add('$d-${querySnapshot.docs[x].id}');
            }
            // });
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    }

    // set data CalendarAllEvent
    CalendarAllEvent calendaralleventModels = CalendarAllEvent(
        uidCheck: uid, dataDate: finishtodos, finishtodosid: finishtodosid);
    controller.calendaralleventModels.add(calendaralleventModels);
  }

  double calculateDistance(
      double lat2, double lng2, RxList<Position> position) {
    double distance = 0.0;
    if (position.isNotEmpty) {
      double lat1 = controller.position.last.latitude;
      double lng1 = controller.position.last.longitude;

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
            controller.position.add(positions);
          }
        } else {
          positions = await Geolocator.getCurrentPosition();
          controller.position.add(positions);
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

  void ClearActivetodo(BuildContext context)  {
    for (var i = 0;
        i < controller.todoresultModels.last.finishtodo.length;
        i++) {
      if (controller.todoresultModels.last.finishtodo[i] == true) {
        context.read<TodoListBloc>().add(ToggleTodoEvent('$i'));
      }
    }
  }
}
