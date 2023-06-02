import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/states/states_login.dart';
import 'package:checkinapp/states/states_qrcode_create.dart';
import 'package:checkinapp/states/states_singin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingApp extends StatelessWidget {
  const SettingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color(0xFF8A2387),
              Color(0xFFE94057),
              Color(0xFFF27121),
            ])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              Container(
                width: 360,
                height: 520,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                            child: buildContainerAvatar(),
                          ),
                          buildCards(
                              context,
                              'Logout',
                              Icons.arrow_forward_ios_rounded,
                              Icons.logout_outlined,
                              1),
                          const Divider(),
                          buildCards(
                              context,
                              'Qr-code Create',
                              Icons.arrow_forward_ios_rounded,
                              Icons.qr_code_rounded,
                              2),
                          const Divider(),
                          buildCards(
                              context,
                              'Singin', //Qr-code Reader
                              Icons.arrow_forward_ios_rounded,
                              Icons.qr_code_scanner,
                              3),
                          const Divider(),
                          buildCards(context, 'Login',
                              Icons.arrow_forward_ios_rounded, Icons.login, 4),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void signOut(BuildContext context) {
  FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginApp()),
      ModalRoute.withName('/'));
}

Widget buildCards(context, title, iconsfrist, icons, tabs) {
  return InkWell(
    child: ListTile(
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: kTextColor)),
      leading: Icon(icons),
      onTap: () {
        if (tabs == 1) {
          signOut(context);
        } else if (tabs == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRcodeCreate()),
          );
        } else if (tabs == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  const SingInApp()),
          );
        } else if (tabs == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginApp()),
          );
        }
      },
    ),
  );
}

Widget buildContainerAvatar() {
  final user = FirebaseAuth.instance.currentUser;
  var email = user?.email.toString();
  return InkWell(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage("assets/images/woman.png"),
            backgroundColor: kTabsColor,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text("$email",
                style: const TextStyle(
                    fontSize: kDefaultFont,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  );
}
