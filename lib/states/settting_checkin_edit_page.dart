// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/factory_all_model.dart';
import 'package:checkinapp/states/settting_checkin_page.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_service.dart';
import 'package:checkinapp/utility/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SettingCheckinEditApp extends StatefulWidget {
  const SettingCheckinEditApp({super.key, required this.factoryModels});
  final FactoryAllModel factoryModels;

  @override
  State<SettingCheckinEditApp> createState() => _SettingCheckinEditAppState();
}

class _SettingCheckinEditAppState extends State<SettingCheckinEditApp> {
  AppController controller = Get.put(AppController());
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController qrController = TextEditingController();
  TextEditingController typeidController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lonController = TextEditingController();
  int factoryId = 0;

  void loadData() {
    titleController.text = widget.factoryModels.title;
    subtitleController.text = widget.factoryModels.subtitle;
    qrController.text = widget.factoryModels.qr;
    typeidController.text = '${widget.factoryModels.typeid}';
    latController.text = '${widget.factoryModels.position.latitude}';
    lonController.text = '${widget.factoryModels.position.longitude}';
    factoryId = widget.factoryModels.id;
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
        backgroundColor: kTabsColor,
        title: const Text(
          "แก้ไขข้อมูล สถานที่",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kDefaultFont,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text('Title'),
                  //   ],
                  // ),
                  buildInputOption(
                    context,
                    'ชื่อจุด',
                    titleController,
                    FontAwesomeIcons.heading,
                    10.0,
                    1,
                    double.infinity,
                    TextInputType.text,
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text('Subtitle'),
                  //   ],
                  // ),
                  buildInputOption(
                    context,
                    'รายละเอียด',
                    subtitleController,
                    FontAwesomeIcons.solidMessage,
                    10.0,
                    10,
                    double.infinity,
                    TextInputType.text,
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text('Qr-Code'),
                  //   ],
                  // ),
                  buildInputOption(
                    context,
                    'รหัส qr-code',
                    qrController,
                    FontAwesomeIcons.qrcode,
                    10.0,
                    1,
                    double.infinity,
                    TextInputType.text,
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text('Type Id'),
                  //   ],
                  // ),
                  buildInputOption(
                    context,
                    'รหัสประเภท',
                    typeidController,
                    FontAwesomeIcons.mapLocationDot,
                    10.0,
                    1,
                    double.infinity,
                    TextInputType.number,
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text('Posision'),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildInputOption(
                      context,
                      'ละติจูด',
                      latController,
                      FontAwesomeIcons.locationDot,
                      10.0,
                      2,
                      170.0,
                      TextInputType.text),
                  const SizedBox(
                    width: 10,
                  ),
                  buildInputOption(
                      context,
                      'ลองจิจูด',
                      lonController,
                      FontAwesomeIcons.locationDot,
                      10.0,
                      2,
                      170.0,
                      TextInputType.text),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  // width: 250,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.green,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'บันทึก',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: kDefaultFont,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                onTap: ()  {
                  checkdata();
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildInputOption(BuildContext context, title, controller,
      icon, top, maxLines, width, keytype) {
    return GestureDetector(
      child: Container(
        width: width,
        margin: EdgeInsets.only(top: top),
        child: TextFormField(
          minLines: 1,
          maxLines: maxLines,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: keytype,
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            filled: true,
            prefixIcon: Icon(icon, color: kPrimaryColor, size: kDefaultFont),
            labelText: title,
          ),
          // obscureText: trfxvbsfvue,
          autovalidateMode: AutovalidateMode.always,
          autocorrect: false,
        ),
      ),
    );
  }

  Future<void> checkdata() async {
    if (titleController.text.isEmpty ||
        subtitleController.text.isEmpty ||
        qrController.text.isEmpty ||
        typeidController.text.isEmpty ||
        latController.text.isEmpty ||
        lonController.text.isEmpty) {
      AppSnackBar(
              title: 'Save Failure', massage: 'Please Fill in Data all input.')
          .errorSnackBar();
    } else {
      try {
        await AppService().updateInfoFactory(
            factoryId,
            titleController.text,
            subtitleController.text,
            typeidController.text,
            latController.text,
            lonController.text,
            qrController.text);
        await AppService().readInfoFactoryAll();
        showAlertDialog(context);
      } catch (e) {
        print(e);
      }
      
    }
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("ตกลง"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        // Get.offAll(() => WidgetBarItem(
        //     currentPage: 3, roleUser: controller.userModels.last.role));
        Get.offAll(() => const SettingCheckinApp());
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("บันทึกสำเร็จ !!"),
      content: const Text("แก้ไขข้อมูลผู้ใช้งานสำเร็จ"),
      actions: [
        okButton,
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
}
