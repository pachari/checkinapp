// ignore_for_file: avoid_function_literals_in_foreach_calls, use_build_context_synchronously, non_constant_identifier_names, avoid_print

import 'dart:io';
import 'dart:math';

import 'package:checkinapp/blocs/todo_list/todo_list_bloc.dart';
import 'package:checkinapp/models/calendarevent_model.dart';
import 'package:checkinapp/models/checktodoresult_model.dart';
import 'package:checkinapp/models/eventforprint_model.dart';
import 'package:checkinapp/models/factory_all_model.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/models/fileupload_model.dart';
import 'package:checkinapp/models/todoresult_forporint_model.dart';
import 'package:checkinapp/models/todoresult_model.dart';
import 'package:checkinapp/models/user_model.dart';
import 'package:checkinapp/models/userlist_model.dart';
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

  Future<void> readFileUpload(String uid, String id, DateTime datadate,
      String imagetodoid, String todoid) async {
    controller.fileuploadModels.clear();
    await db_todo
        .doc(uid)
        .collection(DateFormat('yyyyMMdd').format(datadate))
        .doc(imagetodoid)
        .collection('fileupload')
        // .doc(imagetodoid)
        .where('todoid', isEqualTo: imagetodoid)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        FileUploads fileuploadModels = FileUploads(
            name: value.docs.last['name'],
            remark: value.docs.last['remark'],
            image: value.docs.last['image'],
            uid: uid,
            factoryid: id,
            todoid: todoid);
        controller.fileuploadModels.add(fileuploadModels);
      }
    });
  }

  Future<void> updateInfoFactory(int id, String title, String subtitle,
      String typeid, String lat, String lon, String qr) async {
    await FirebaseFirestore.instance.collection('checkin').doc('id$id').update({
      'position': GeoPoint(double.parse(lat), double.parse(lon)),
      'qr': qr,
      'subtitle': subtitle,
      'title': title,
      'typeid': int.parse(typeid),
      'id': id,
    });
  }

  Future<void> addInfoFactory(int id, String title, String subtitle,
      String typeid, String lat, String lon, String qr) async {
    await FirebaseFirestore.instance.collection('checkin').doc('id$id').set({
      'position': GeoPoint(double.parse(lat), double.parse(lon)),
      'qr': qr,
      'subtitle': subtitle,
      'title': title,
      'typeid': int.parse(typeid),
      'id': id,
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

  Future<void> readInfoFactoryAll() async {
    controller.factoryAllModels.clear();
    await db
        .collection('checkin')
        .orderBy('typeid')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        controller.factoryAllModels.add(FactoryAllModel(
            position: doc["position"],
            qr: doc["qr"],
            subtitle: doc["subtitle"],
            title: doc["title"],
            typeid: doc["typeid"],
            id: doc["id"]));
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
    controller.userModels.clear();
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

  Future<void> readUserListModel() async {
    controller.userlistModels.clear();

    await db.collection('user').orderBy('email').get().then((value) async {
      if (value.docs.isNotEmpty) {
        for (var i = 0; i < value.docs.length; i++) {
          await db.collection('user').doc(value.docs[i].id).get().then(
            (val) {
              var array = val['todo']; // array is now List<dynamic>
              List<String> strings = List<String>.from(array);
              UserListModel userlistModels = UserListModel(
                email: val['email'],
                name: val['name'],
                role: val['role'],
                todo: strings,
                uid: val['uid'],
                typeworkid: val['typeid'],
              );
              controller.userlistModels.add(userlistModels);
            },
          );
        }
      }
    });
  }

  Future<void> CheckTodoResultModel(
      int eventid, String datadate, String docid) async {
    List<String> resultdocid = [];
    // var formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
    //Check type from page / 0 = calendar / >0 = todolist_state
    if (eventid == 0 && docid.isNotEmpty) {
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

      // // เป็นการ select todolist result
      // await db_todo
      //     .doc(_auth?.uid)
      //     .collection(datadate)
      //     .doc(docid)
      //     // .doc("checkinid$eventid")
      //     .get()
      //     .then((value) {
      //   if (value.data() != null) {
      //     Map<String, dynamic> data = value.data() as Map<String, dynamic>;
      //     // value.docs.forEach((doc) {
      //       resultdocid.add(docid);
      //     // });
      //     // controller.checktodoresultModels.clear();
      //     // if (value.docs.isEmpty) {
      //     //   CheckTodoResultModels checktodoresultModels = CheckTodoResultModels(
      //     //       result: (0),
      //     //       resultcheckinid: resultdocid,
      //     //       collectiondate: datadate);
      //     //   controller.checktodoresultModels.add(checktodoresultModels);
      //     // } else {
      //       }
      //       CheckTodoResultModels checktodoresultModels = CheckTodoResultModels(
      //           result: (1),
      //           resultcheckinid: resultdocid,
      //           collectiondate: datadate);
      //       controller.checktodoresultModels.add(checktodoresultModels);

      // }

      // });
    } else {
      // เป็นการ insert collection แยก ไม่ต่อท้ายตัวไหน ขึ้นใหม่เลย
      await db_todo //.where('uidCheck', isEqualTo: _auth!.uid)
          .doc(_auth?.uid)
          .collection(datadate)
          .where('checkinid', isEqualTo: eventid)
          .where('todostatus', isEqualTo: 1)
          // .doc("$eventid")
          .get()
          .then((value) {
        controller.checktodoresultModels.clear();
        resultdocid = [];
        if (value.docs.isEmpty) {
          CheckTodoResultModels checktodoresultModels = CheckTodoResultModels(
            result: (0),
            resultcheckinid: resultdocid,
            collectiondate: datadate,
          );
          controller.checktodoresultModels.add(checktodoresultModels);
        } else {
          resultdocid.add(value.docs[0].id);
          CheckTodoResultModels checktodoresultModels = CheckTodoResultModels(
              result: (1),
              resultcheckinid: resultdocid,
              collectiondate: datadate);
          controller.checktodoresultModels.add(checktodoresultModels);
        }
      });
    }
  }

  Future<void> readTodoResultModel(
      String uid, String eventid, String datadate) async {
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
        .doc(uid) //_auth?.uid
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
            checkinid: data['checkinid'],
            image: eventid,
            todostatus: data['todostatus'],
            todoresultid: data['image'] ?? '');

        controller.todoresultModels.add(todoresultModels);
        finishtodos = [];
      }
    });
  }

  Future<void> readTodoResultforPrintModel(String uid, String startdate,
      String enddate, String username, List<String> todoname) async {
    controller.alleventforpirntModels.clear();
    controller.todoresultforprintModels.clear();
    String formattedDate =
        DateFormat('yyyyMM').format(DateTime.parse(startdate));
    DateTime st = DateTime.parse(startdate);
    DateTime en = DateTime.parse(enddate);
    List<bool> todos = [];
    List<String> finishtodos = [];
    List<String> finishtodosid = [];
    // DateTime dataDate = DateTime(st.year, st.month, st.day);
    // DateTime dataDate2 = DateTime(en.year, en.month, en.day);
    // int inDays = dataDate2.difference(dataDate).inDays;

    String d = '';
    for (var i = st.day; i <= en.day; i++) {
      if (i < 10) {
        d = '${formattedDate}0$i';
      } else {
        d = '$formattedDate$i';
      }
      // set data result date save
      await db_todo.doc(uid).collection(d).orderBy('timestampIn').get().then(
        //.orderBy('checkinid')
        (querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            finishtodos.add(d);
            for (var x = 0; x < querySnapshot.docs.length; x++) {
              finishtodosid.add('$d-${querySnapshot.docs[x].id}');

              await db_todo
                  .doc(uid)
                  .collection(d)
                  .doc(querySnapshot.docs[x].id)
                  .get()
                  .then((value) {
                if (value.data() != null) {
                  Map<String, dynamic> data =
                      value.data() as Map<String, dynamic>;
                  todos = [];
                  for (var i = 0; i < data['finishtodo'].length; i++) {
                    if (data['finishtodo'][i] == true) {
                      todos.add(true);
                    } else {
                      todos.add(false);
                    }
                  }
                  TodoResultForPrintModels todoresultforprintModels =
                      TodoResultForPrintModels(
                          uidCheck: data['uidCheck'],
                          timestampIn: data['timestampIn'],
                          timestampOut: data['timestampOut'],
                          finishtodo: todos,
                          checkinid: data['checkinid'],
                          image: data['image'] ?? '', //querySnapshot.docs[x].id
                          todostatus: data['todostatus'],
                          todo: todoname,
                          todoid: querySnapshot.docs[x].id);

                  controller.todoresultforprintModels
                      .add(todoresultforprintModels);
                }
              });
            }
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    }

    // set data CalendarAllEvent
    AlleventforPrint alleventforpirntModels = AlleventforPrint(
        uidCheck: uid,
        dataDate: finishtodos,
        finishtodosid: finishtodosid,
        name: username,
        beginDate: startdate,
        endDate: enddate);
    controller.alleventforpirntModels.add(alleventforpirntModels);
  }

  // Future<void> readCalendarallEventModel(String uid, int days) async {
  //   var formattedDate = DateFormat('yyyyMM').format(DateTime.now());
  //   List<String> finishtodos = [];
  //   String d = '';
  //   for (var i = 1; i <= days; i++) {
  //     if (i < 10) {
  //       d = '${formattedDate}0$i';
  //     } else {
  //       d = '$formattedDate$i';
  //     }
  //     await db_todo.doc(uid).collection(d).get().then(
  //       (querySnapshot) {
  //         if (querySnapshot.docs.isNotEmpty) {
  //           finishtodos.add(d);
  //         }
  //       },
  //       onError: (e) => print("Error completing: $e"),
  //     );
  //   }
  //   CalendarAllEvent calendaralleventModels = CalendarAllEvent(
  //       uidCheck: uid, dataDate: finishtodos, finishtodosid: []);
  //   controller.calendaralleventModels.add(calendaralleventModels);
  // }

  Future<void> readCalendarallEventModel2(String uid, DateTime datadate) async {
    var datemonth = DateFormat('yyyyMM').format(datadate);
    List<String> finishtodos = [];
    List<String> finishtodosid = [];
    List<String> listsmonth = [datemonth];
    // DateTime dataDate = DateTime(datadate.year, datadate.month, 0);
    // DateTime dataDate2 = DateTime(datadate.year, datadate.month + 1, 0);
    // int inDays = dataDate2.difference(dataDate).inDays;
    // int aLlDays = dataDate1.difference(dataDate).inDays;
    String d = '';
    // datemonth.add(datemonth);
    // if (controller.calendaralleventModels.isNotEmpty && controller.calendaralleventModels.last.uidCheck == uid) {
    //   // for (var i = 0;
    //   //     i < controller.calendaralleventModels.last.datamonth.length;
    //   //     i++) {
    //   //   if (controller.calendaralleventModels.last.datamonth[i] != datemonth) {
    //   //     searchBooleanmonth = true;
    //   //   }
    //   // }
    //   // if (searchBooleanmonth == true) {
    //     // for (var i = 0; i < 2; i++) {
    //     //   if (i > 0) {
    //     //     datemonth = DateFormat('yyyyMM')
    //     //         .format(DateTime(datadate.year, datadate.month, 0));
    //     //     listsmonth.add(datemonth);
    //     //   }
    //       for (var z = 1; z <= 31; z++) {
    //         if (z < 10) {
    //           d = '${datemonth}0$z';
    //         } else {
    //           d = '$datemonth$z';
    //         }
    //         // set data result date save
    //         await db_todo.doc(uid).collection(d).get().then(
    //           (querySnapshot) async {
    //             if (querySnapshot.docs.isNotEmpty) {
    //               finishtodos.add(d);
    //               for (var x = 0; x < querySnapshot.docs.length; x++) {
    //                 finishtodosid.add('$d-${querySnapshot.docs[x].id}');
    //               }
    //               // });
    //             }
    //           },
    //           onError: (e) => print("Error completing: $e"),
    //         );
    //       }
    //     // }
    //     // set data CalendarAllEvent
    //     CalendarAllEvent calendaralleventModels = CalendarAllEvent(
    //         uidCheck: uid,
    //         dataDate: finishtodos,
    //         finishtodosid: finishtodosid,
    //         datamonth: listsmonth);
    //     controller.calendaralleventModels.add(calendaralleventModels);
    //   // }
    // } else {
      for (var i = 0; i < 2; i++) {
        if (i > 0) {
          datemonth = DateFormat('yyyyMM')
              .format(DateTime(datadate.year, datadate.month, 0));
          listsmonth.add(datemonth);
        }
        for (var z = 1; z <= 31; z++) {
          if (z < 10) {
            d = '${datemonth}0$z';
          } else {
            d = '$datemonth$z';
          }
          // set data result date save
          await db_todo.doc(uid).collection(d).get().then(
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
      }
      // set data CalendarAllEvent
      CalendarAllEvent calendaralleventModels = CalendarAllEvent(
          uidCheck: uid,
          dataDate: finishtodos,
          finishtodosid: finishtodosid,
          datamonth: listsmonth);
      controller.calendaralleventModels.add(calendaralleventModels);
    // }
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
        title:
            'กรุณาอนุญาตให้ Checkin-in App ระบุตำแหน่ง ', //Permission Location
        content: 'แจ้งเตือน!',
        firstAction: WidgetButton(
          label: 'ตั้งค่าสิทธิ์', //Open Permission
          pressFunc: () {
            Geolocator.openAppSettings();
            exit(0);
          },
        ));
  }

  void ClearActivetodo(BuildContext context) {
    for (var i = 0; i < controller.userModels.last.todo.length; i++) {
      context.read<TodoListBloc>().add(ClearTodoEvent('$i'));
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month); //, from.day
    to = DateTime(to.year, to.month); //, to.day
    return (to.difference(from).inHours / 24).round();
  }
}
