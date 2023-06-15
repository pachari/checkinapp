// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/factory_model.dart';
// import 'package:checkinapp/states/states_qrcode_reader.dart';
import 'package:checkinapp/states/states_todolist.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_dialog.dart';
import 'package:checkinapp/utility/app_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Listcheckin extends StatefulWidget {
  const Listcheckin({super.key});

  @override
  ListcheckinState createState() => ListcheckinState();
}

final user = FirebaseAuth.instance.currentUser;

class ListcheckinState extends State<Listcheckin> {
  List factorys = [];
  List original = [];
  Color bg = kPrimaryColor;
  int checkbg = 0;
  int typeRoleid = 1;
  TextEditingController txtQuery = TextEditingController();
  AppController controller = Get.put(AppController());

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
        typeid, DateFormat('yyyyMMdd').format(DateTime.now()));
    if (controller.checktodoresultModels.last.result > 0) {
      return bg = Colors.green;
    } else {
      return bg = kPrimaryColor.withOpacity(0.9);
    }
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: const Text(
          "Check-in",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10,),
        child: SizedBox(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 30, right: 20, top: 0, bottom: 0),
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
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(25.0),
                                gapPadding: 1),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: kselectedItemColor,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
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
    );
  }

  Widget _listView() {
    double distance = 0.0;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: ListView.builder(
            itemExtent: 60.0, //80 ป้าเหมียว
            itemCount: factorys.length,
            itemBuilder: (context, index) {
              var factory = factorys[index];
              // var id = (index + 1);
              return FutureBuilder(
                future: loadDataTodoResult(factory.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundColor: snapshot.data,
                        child: const Icon(Icons.maps_home_work_sharp,
                            color: kPrimaryLightColor)
                        ),
                    title: Text(
                      factory.title,
                      style: const TextStyle(
                          color: Colors.red, fontSize: 15,fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(factory.subtitle,style: const TextStyle(
                          color: kTextColor, fontSize: 15)),
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
                                    factoryModel:
                                        controller.factoryModels[index],
                                  )),
                        );
                        // Navigator.of(context, rootNavigator: true).pop();
                        // Get.offAll(() => ToDoList( factoryModel: controller.factoryModels[index], ));
                        //Real
                        // Navigator.of(context, rootNavigator: true).pop();
                        // Get.offAll(() => QRcodeReader(
                        //       factoryModel: controller.factoryModels[index],
                        //     ));
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
                },
              );
            }),
      ),
    );
  }
}
