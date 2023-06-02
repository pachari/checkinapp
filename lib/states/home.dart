// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/states/states_todolist.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_curved.dart';
import 'package:checkinapp/utility/app_dialog.dart';
import 'package:checkinapp/utility/app_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

final user = FirebaseAuth.instance.currentUser;
String? email = user?.email;

class HomePageState extends State<HomePage> {
  List factorys = [];
  List original = [];
  // Color bg = kPrimaryColor;
  int checkbg = 0;
  TextEditingController txtQuery = TextEditingController();
  AppController controller = Get.put(AppController());

  Future<void> readInfoFactory() async {
    if (controller.factoryModels.isNotEmpty) {
      controller.factoryModels.clear();
    }
    await FirebaseFirestore.instance
        .collection('checkin')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        controller.factoryModels.add(FactoryModel(
            position: doc["position"],
            qr: doc["qr"],
            subtitle: doc["subtitle"],
            title: doc["title"],
            typeid: doc["typeid"]));
      });
    });

    loadData();
  }

  void loadData() async {
    // String jsonStr = await rootBundle.loadString('assets/factorys.json');
    // var json = jsonDecode(jsonStr);
    factorys = controller.factoryModels;
    original = controller.factoryModels;
    AppService().processFindPosition(context: context);
    AppService().readUserModel();
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

  // void loadDataTodoResult(int typeid) async {
  //   await AppService().CheckTodoResultModel(
  //       typeid, DateFormat('yyyyMMdd').format(DateTime.now()));

  //   if (controller.checktodoresultModels.last.result != 0) {
  //     await AppService().readTodoResultModel(
  //         typeid, DateFormat('yyyyMMdd').format(DateTime.now())); 
  //   }
  // }

  @override
  void initState() {
    super.initState();
    readInfoFactory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurvedWidget(
              child: Container(
                padding: const EdgeInsets.only(top: 60, left: 50),
                width: double.infinity,
                height: 180,
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
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '$email',
                          style: const TextStyle(
                              fontSize: kDefaultFont,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 30, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: txtQuery,
                      onChanged: search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(25.0),
                        //     gapPadding: 0),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: kPrimaryColor),
                            borderRadius: BorderRadius.circular(25.0),
                            gapPadding: 10),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: kselectedItemColor,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          splashColor: Colors.red,
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
    );
  }

  Widget _listView() {
    double distance = 0.0;
    Color bg = kPrimaryColor;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: ListView.builder(
            itemExtent: 60.0,
            itemCount: factorys.length,
            itemBuilder: (context, index) {
              var factory = factorys[index];
              var id = (index + 1);
              // loadDataTodoResult(factory.typeid);
              // if (checkbg == 1) {
              //   bg = Colors.green;
              // } 
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: bg,
                  child: Text(
                    '$id',
                    style: const TextStyle(
                        color: kPrimaryLightColor, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  factory.title,
                  style: const TextStyle(
                      color: kTextColor, fontSize: kDefaultFont),
                ),
                subtitle: Text(factory.subtitle),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  distance = AppService().calculateDistance(
                      factory.position.latitude,
                      factory.position.longitude,
                      controller.position);
                  print('dis $distance');
                  if (distance <= 50.0 && distance > 0) {
                    //test
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ToDoList(
                                factoryModel: controller.factoryModels[index],
                              )),
                    );
                    //Real
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>  QRcodeReader(factoryModel: controller.factoryModels[index],)),
                    // );
                  } else if (distance == 0) {
                    AppDialog(context: context).normalDialog(
                        title: 'Please check your location on.',
                        content: 'Worning! Location');
                  } else {
                    String piAsString = distance.toStringAsFixed(0);
                    AppDialog(context: context).normalDialog(
                        title:
                            'Please keep your distance < 50 M, and Now the distance from the checkpoint = $piAsString M.',
                        content: 'Worning! Distance');
                  }
                },
              );
            }),
      ),
    );
  }
}
