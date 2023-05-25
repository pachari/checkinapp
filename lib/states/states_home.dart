import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/utility/app_curved.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

final user = FirebaseAuth.instance.currentUser;
String? email = user?.email;

class _HomeAppState extends State<HomeApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CurvedWidget(
            child: Container(
              padding: const EdgeInsets.only(top: 80, left: 50),
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kPrimaryColor,
                    kPrimaryColor.withOpacity(0.6),
                    // const Color.fromARGB(250, 54, 51, 255),
                    // kTabsColor.withOpacity(0.4)
                  ], //Colors.red.withOpacity(0.4)
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
                          fontSize: 40,
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
                            // fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 200, left: 10, right: 10),
              child: Container(
                width: double.infinity,
                height: 500,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    buildCards(),
                  ],
                ),
                // child: ListView(children: [
                //   buildCards(context, 'Check-in 1',
                //       Icons.arrow_forward_ios_rounded, Icons.list_alt_sharp, 2),
                //   buildCards(context, 'Check-in 2',
                //       Icons.arrow_forward_ios_rounded, Icons.list_alt_sharp, 2),
                //   buildCards(context, 'Check-in 3',
                //       Icons.arrow_forward_ios_rounded, Icons.list_alt_sharp, 2),
                //   buildCards(context, 'Check-in 4',
                //       Icons.arrow_forward_ios_rounded, Icons.list_alt_sharp, 2),
                //   buildCards(context, 'Check-in 5',
                //       Icons.arrow_forward_ios_rounded, Icons.list_alt_sharp, 2),
                //   buildCards(context, 'Check-in 1',
                //       Icons.arrow_forward_ios_rounded, Icons.list_alt_sharp, 2),
                //   buildCards(context, 'Check-in 2',
                //       Icons.arrow_forward_ios_rounded, Icons.list_alt_sharp, 2),
                //   buildCards(context, 'Check-in 3',
                //       Icons.arrow_forward_ios_rounded, Icons.list_alt_sharp, 2),
                //   buildCards(context, 'Check-in 4',
                //       Icons.arrow_forward_ios_rounded, Icons.list_alt_sharp, 2),
                //   buildCards(context, 'Check-in 5',
                //       Icons.arrow_forward_ios_rounded, Icons.list_alt_sharp, 2),
                // ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildCards() {
  //context, title, iconsfrist, icons, tabs
  final List<String> entries = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'T',
    'Z'
  ];
  final List<int> colorCodes = <int>[
    900,
    800,
    700,
    600,
    500,
    400,
    300,
    200,
    100,
    50
  ];
  return ListView.separated(
    padding: const EdgeInsets.all(8),
    itemCount: entries.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
        color: Colors.amber[colorCodes[index]],
        child: Center(child: Text('Entry ${entries[index]}')),
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
  // return InkWell(
  //   child: Card(
  //     // elevation: 1,
  //     // shape: const RoundedRectangleBorder(
  //     //   borderRadius: BorderRadius.all(Radius.circular(5)),
  //     // ),
  //     child: ListTile(
  //       title: Text(title,
  //           style: const TextStyle(
  //               fontWeight: FontWeight.bold, fontSize: 16, color: kTextColor)),
  //       leading: Icon(icons),
  //       trailing: Icon(iconsfrist),
  //       onTap: () {
  //         // if (tabs == 1) {
  //         //   // signOut(context);
  //         // } else {
  //         //   signOut(context);
  //         // }
  //       },
  //     ),
  //   ),
  // );
}

