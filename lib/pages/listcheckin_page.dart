// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, use_build_context_synchronously

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/cubits/todo_list/filtered_todos_list.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/pages/todolist_page.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_dialog.dart';
import 'package:checkinapp/utility/app_service.dart';
import 'package:checkinapp/widgets/widget_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Listcheckin extends StatefulWidget {
  const Listcheckin({super.key});

  @override
  ListcheckinState createState() => ListcheckinState();
}

final user = FirebaseAuth.instance.currentUser;

class ListcheckinState extends State<Listcheckin> {
  double distance = 0.0;
  List factorys = [];
  List original = [];
  Color bg = kPrimaryColor;
  int checkbg = 0;
  int typeRoleid = 1;
  TextEditingController txtQuery = TextEditingController();
  AppController controller = Get.put(AppController());
  Map<MarkerId, Marker> mapMarkers = {};
  List<String> docid = [];

  Future<void> readInfoFactory() async {
    if (controller.factoryModels.isNotEmpty) {
      controller.factoryModels.clear();
    }
    // await AppService().readUserModel();
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

  void loadData() {
    // String jsonStr = await rootBundle.loadString('assets/factorys.json');
    // var json = jsonDecode(jsonStr);
    factorys = controller.factoryModels;
    original = controller.factoryModels;
    setState(() {});
  }

  void search(String query) {
    if (query.isEmpty) {
      factorys = original;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    List result = [];
    factorys.forEach((p) {
      var subtitle = p.subtitle.toString().toLowerCase();
      if (subtitle.contains(query)) {
        result.add(p);
      }
    });

    factorys = result;
    setState(() {});
  }

  Future loadDataTodoResult(int typeid) async {
    await AppService().CheckTodoResultModel(
        typeid, DateFormat('yyyyMMdd').format(DateTime.now()), '');
    if (controller.checktodoresultModels.last.resultcheckinid.isNotEmpty) {
      docid = controller.checktodoresultModels.last.resultcheckinid;
      return true; //bg = Colors.green;
    } else {
      return false; //bg = kPrimaryColor.withOpacity(0.9);
    }
  }

  @override
  void initState() {
    super.initState();
    readInfoFactory();
    // loadData();
    aboutPositionAndMarker();
    // addMarkerFactory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: const Text(
          "จุดเช็คอิน",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Container(
        color: kBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: SizedBox(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, top: 0, bottom: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: txtQuery,
                            onChanged: search,
                            decoration: InputDecoration(
                              hintText: "ค้นหา",
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(25.0),
                              //     gapPadding: 0),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: kTrushColor),
                                  borderRadius:
                                      BorderRadius.circular(kDefaultCircular),
                                  gapPadding: 1),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: kselectedItemColor,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: kTrushColor,
                                ),
                                onPressed: () {
                                  txtQuery.text = '';
                                  search(txtQuery.text);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _listView()
                ]),
          ),
        ),
      ),
    );
  }

  Widget _listView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: ListView.builder(
            itemExtent: 60.0, //80 ป้าเหมียว / default 60
            itemCount: factorys.length,
            itemBuilder: (context, index) {
              var factory = factorys[index];
              // var id = (index + 1);
              return FutureBuilder(
                future: loadDataTodoResult(factory.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundColor: snapshot.data == true
                            ? Colors.green
                            : kPrimaryColor,
                        child: const Icon(Icons.pin_drop, //maps_home_work_sharp
                            color: Colors.white)),
                    title: Text(
                      factory.title,
                      style: const TextStyle(
                          color: kTextColor,
                          fontSize: kDefaultFont, //12 ป้าเหมียว
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(factory.subtitle,
                        style: const TextStyle(
                            color: kselectedItemColor,
                            fontSize: kDefaultFont)), //12
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      // เอาไว้เช็คกรณีเคยกดเข้าเยี่ยมแล้ว ไม่ต้องแจ้งเตือนอีก
                      if (snapshot.data == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ToDoList(
                                  factoryModel: controller.factoryModels[index],
                                  todoid: docid[0])),
                        );
                      } else {
                        showAlertDialog(
                            context,
                            index,
                            factory.position.latitude,
                            factory.position.longitude);
                      }
                    },
                  );
                },
              );
            }),
      ),
    );
  }

  Future<void> checkdistance(
      double distance, BuildContext context, int index) async {
    List finishtodo = [];
    final CollectionReference reference = FirebaseFirestore.instance
        .collection('todolist')
        .doc(user?.uid)
        .collection(DateFormat('yyyyMMdd').format(DateTime.now()));
    if (distance <= 30 && distance > 0) {
      for (var i = 0; i < TodoListState.initial().todos.length; i++) {
        finishtodo.add(TodoListState.initial().todos[i].completed);
      }
      //ใช้กรณี อยากให้เป็นการเข้าเยี่ยมครั้งเดียว
      // reference.doc("id${controller.factoryModels[index].id}").set({
      //ใช้กรณี อยากให้เป็นการเข้าเยี่ยมได้หลายครั้งใน 1 จุด
      final insertid = await reference.add({
        "finishtodo": finishtodo,
        "timestampIn": DateTime.now(),
        "timestampOut": DateTime.now(),
        "uidCheck": user?.uid,
        "checkinid": controller.factoryModels[index].id,
        "image": '',
        "todostatus": 1
      });
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ToDoList(
                factoryModel: controller.factoryModels[index],
                todoid: insertid.id)), //
      );
    } else if (distance == 0) {
      Navigator.of(context, rootNavigator: true).pop();
      AppDialog(context: context).normalDialog(
          title:
              'กรุณาเปิด Location เพื่อระบุตำแหน่ง', //Please check your location on.
          content: 'Location!!'); //Worning! Location
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      String piAsString = distance.toStringAsFixed(0);
      AppDialog(context: context).normalDialog(
          title:
              'เนื่องจากคุณไม่อยู่ภายในรัศมีของจุดเช็คอิน จึงไม่สามารถเข้าเช็คอินได้ ระยะห่าง $piAsString เมตร ', //Please keep your distance < 50 M, and Now the distance from the checkpoint = $piAsString M.
          content: 'แจ้งเตือน!!'); //'Worning! Distance
    }
  }

  showAlertDialog(BuildContext context, index, latitude, longitude) async {
    mapMarkers = {};
    addMarkerFactorySelect(index);
    aboutPositionAndMarker();

    // set up the button
    Widget okButton = TextButton(
      child: const Text("ตกลง"),
      onPressed: () {
        distance = AppService()
            .calculateDistance(latitude, longitude, controller.position);
        checkdistance(distance, context, index);
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("ยกเลิก"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Check-in"),
      content: const Text("เข้าเช็คอิน ใช่หรือไม่? "),
      actions: [
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              child: GetX(
                  init: AppController(),
                  builder: (AppController appController) {
                    print(
                        '## fac lat --> ${appController.factoryModels.length}');
                    return appController.position.isEmpty
                        ? const SizedBox()
                        : WidgetMap(
                            latLng: LatLng(appController.position.last.latitude,
                                appController.position.last.longitude),
                            mapMarkers: mapMarkers,
                          );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cancelButton,
                okButton,
              ],
            ),
          ],
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // void addMarkerFactory() {
  //   for (var i = 0; i < controller.factoryModels.length; i++) {
  //     MarkerId markerId = MarkerId('Factory $i');
  //     Marker marker = AppService().createMarker(
  //       latLng: LatLng(
  //           controller.factoryModels[i].position.latitude,
  //           controller.factoryModels[i].position
  //               .longitude), //controller.factoryModels[i].lat, controller.factoryModels[i].lng
  //       markerId: markerId,
  //       title: controller.factoryModels[i].title,
  //       subtitle: controller.factoryModels[i].subtitle,
  //     );
  //     mapMarkers[markerId] = marker;
  //   }
  // }

  void addMarkerFactorySelect(int index) {
    // for (var i = 0; i < controller.factoryModels.length; i++) {
    MarkerId markerId = MarkerId('Factory $index');
    Marker marker = AppService().createMarker(
      latLng: LatLng(
          controller.factoryModels[index].position.latitude,
          controller.factoryModels[index].position
              .longitude), //controller.factoryModels[i].lat, controller.factoryModels[i].lng
      markerId: markerId,
      title: controller.factoryModels[index].title,
      subtitle: controller.factoryModels[index].subtitle,
    );
    mapMarkers[markerId] = marker;
    // }
  }

  void aboutPositionAndMarker() {
    AppService().processFindPosition(context: context).then((value) {
      MarkerId markerId = const MarkerId('idUser');
      if (controller.position.isNotEmpty) {
        Marker marker = AppService().createMarker(
            latLng: LatLng(controller.position.last.latitude,
                controller.position.last.longitude),
            markerId: markerId,
            title: 'คุณอยู่ที่นี่',
            subtitle: 'You Here',
            hue: 0);

        mapMarkers[markerId] = marker;
      }
    });
  }
}
