// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, prefer_interpolation_to_compose_strings

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/states/states_qrcode_reader.dart';
import 'package:checkinapp/utility/app_curved.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

final user = FirebaseAuth.instance.currentUser;
String? email = user?.email;

class HomePageState extends State<HomePage> {
  List persons = [];
  List original = [];
  TextEditingController txtQuery = TextEditingController();

  void loadData() async {
    String jsonStr = await rootBundle.loadString('assets/persons.json');
    var json = jsonDecode(jsonStr);
    persons = json;
    original = json;
    setState(() {});
  }

  void search(String query) {
    if (query.isEmpty) {
      persons = original;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    print(query);
    List result = [];
    persons.forEach((p) {
      var name = p["subtitle"].toString().toLowerCase();
      if (name.contains(query)) {
        result.add(p);
      }
    });

    persons = result;
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
                      // kPrimaryColor,
                      // kPrimaryColor.withOpacity(0.6),
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
                          ),
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
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("List view search",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: kDefaultFont,
                            color: kTextColor)),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: txtQuery,
                      onChanged: search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            gapPadding: 0),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(25.0),
                            gapPadding: 0),
                        prefixIcon: const Icon(Icons.search),
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
            _listView(persons)
          ]),
    );
  }
}

Widget _listView(persons) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView.builder(
          itemExtent: 60.0,
          itemCount: persons.length,
          itemBuilder: (context, index) {
            var person = persons[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: kselectedItemColor,
                child: Text(
                  "${person['id']}"[0],
                  style: const TextStyle(
                      color: kPrimaryLightColor, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                "${person['title']}",
                style:
                    const TextStyle(color: kTextColor, fontSize: kDefaultFont),
              ),
              subtitle: Text(person['subtitle']),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRcodeReader()),
                );
              },
            );
          }),
    ),
  );
}
