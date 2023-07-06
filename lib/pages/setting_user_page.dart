// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/pages/setting_user_edit_page.dart';
import 'package:checkinapp/pages/singin_page.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersApp extends StatefulWidget {
  const UsersApp({super.key});

  @override
  State<UsersApp> createState() => _UsersAppState();
}

class _UsersAppState extends State<UsersApp> {
  AppController controller = Get.put(AppController());
  TextEditingController txtQuery = TextEditingController();
  List factorys = [];
  List original = [];

  void loadData() {
    factorys = controller.userlistModels;
    original = controller.userlistModels;
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
      var subtitle = p.name.toString().toLowerCase();
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
          "จัดการผู้ใช้งาน",
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
            MaterialPageRoute(builder: (context) => const SingInApp()),
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
              title: Text(factorys[index].name),
              subtitle: Text(factorys[index].email),
              leading: const Icon(
                Icons.account_circle_sharp,
                size: 40,
                // color: kPrimaryColor,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                // color: kPrimaryColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserEditApp(
                          userlistModels: controller.userlistModels[index])),
                );
              });
        },
      ),
    );
  }
}
