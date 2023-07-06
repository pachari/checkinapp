import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/pages/calendar_page.dart';
import 'package:checkinapp/pages/export_checkin_page.dart';
import 'package:checkinapp/pages/settting_checkin_page.dart';
import 'package:checkinapp/pages/login_page.dart';
import 'package:checkinapp/pages/qrcode_create_page.dart';
import 'package:checkinapp/pages/setting_user_page.dart';
import 'package:checkinapp/utility/app_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingApp extends StatefulWidget {
  const SettingApp({super.key});

  @override
  State<SettingApp> createState() => _SettingAppState();
}

class _SettingAppState extends State<SettingApp> {
  void loaddata() async {
    if (controller.userlistModels.isEmpty) {
      await AppService().readUserListModel();
    }
  }

  @override
  void initState() {
    super.initState();
    loaddata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: const Text(
          "ตั้งค่า",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              // size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              signOut(context);
            },
          )
        ],
      ),
      body: Container(
        //SingleChildScrollView
        color: kBackgroundColor,
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
              //   child: buildContainerAvatar(),
              // ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Icon(Icons.person, color: kPrimaryColor),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'จัดการข้อมูล',
                    style: TextStyle(
                        fontSize: kDefaultFont + 1,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(
                height: 10,
                thickness: 1,
              ),
              buildMenuOption(context, 'จัดการผู้ใช้งาน', const UsersApp()),
              // buildMenuOption(context, 'ลงทะเบียนผู้ใช้งาน', const SingInApp()),
              // buildMenuOption(context, 'จัดการประเภทผู้ใช้งาน', const SettingCheckinApp()),
              buildMenuOption(
                  context, 'จัดการสถานที่', const SettingCheckinApp()),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.qr_code_rounded,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'QR-Code',
                    style: TextStyle(
                        fontSize: kDefaultFont + 1,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(
                height: 10,
                thickness: 1,
              ),
              buildMenuOption(context, 'สร้าง QR-code', const QRcodeCreate()),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.qr_code_rounded,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Exports',
                    style: TextStyle(
                        fontSize: kDefaultFont + 1,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(
                height: 10,
                thickness: 1,
              ),
              buildMenuOption(
                  context, 'รายการเช็คอิน', const ExportCheckInApp()),

              // buildMenuOption(context, 'แสกน QR-code', const QRcodeReader()),
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
      MaterialPageRoute(builder: (context) => const LoginAndSignup()),
      ModalRoute.withName('/'));
}

GestureDetector buildMenuOption(BuildContext context, title, tabs) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => tabs),
      );
    },
    child: ListTile(
      title: Text(title,
          style: const TextStyle(
              fontSize: kDefaultFont,
              fontWeight: FontWeight.w500,
              color: kTextColor)),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: kDefaultFont,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => tabs),
        );
      },
      dense: true,
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
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: const EdgeInsets.all(5),
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
