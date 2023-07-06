// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/pages/settting_checkin_create_page.dart';
import 'package:checkinapp/pages/settting_checkin_edit_page.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingCheckinApp extends StatefulWidget {
  const SettingCheckinApp({super.key});

  @override
  State<SettingCheckinApp> createState() => _SettingCheckinAppState();
}

class _SettingCheckinAppState extends State<SettingCheckinApp> {
  AppController controller = Get.put(AppController());
  TextEditingController txtQuery = TextEditingController();
  List factorys = [];
  List original = [];

  void loadData() {
    factorys = controller.factoryAllModels;
    original = controller.factoryAllModels;

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

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: kPrimaryColor,
        title: const Text(
          "จัดการสถานที่",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kDefaultFont,
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
                  _listView(context)
                ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>  SettingCheckinCreateApp(lastfactoryId:controller.factoryAllModels.length)),
          );
        },
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemExtent: 60.0,
        itemCount: factorys.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(factorys[index].title),
              subtitle: Text(factorys[index].subtitle),
              leading: CircleAvatar(
                  backgroundColor: kselectedItemColor,
                  child: Text(
                    '${factorys[index].typeid}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  )),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                // color: kPrimaryColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingCheckinEditApp(
                          factoryModels: controller.factoryAllModels[index])),
                );
              });
        },
      ),
    );
  }
}
