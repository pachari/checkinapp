// import 'package:checkinapp/componants/background.dart';
// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:checkinapp/componants/constants.dart';

class QRcodeCreate extends StatefulWidget {
  const QRcodeCreate({super.key});

  @override
  State<QRcodeCreate> createState() => _QRcodeCreateState();
}

class _QRcodeCreateState extends State<QRcodeCreate> {
  final controller = TextEditingController();
  final qrKey = GlobalKey();

  takeScreenShot(ref) async {
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {
      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
          '$directory/${DateTime.now()}$ref.png',
        );
        imgFile.writeAsBytes(pngBytes);
        await GallerySaver.saveImage(imgFile.path).then((success) async {
          showAlertDialogok(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: const Text(
            "สร้าง QR-code",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // QrImageView(
              //   data: controller.text,
              //   size: 200,
              // ),
              RepaintBoundary(
                key: qrKey,
                child: QrImageView(
                  data: controller.text,
                  size: 200,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text('กรอก QR-code id ที่ระบุไว้กับสถานที่ '),
              buildTextField(context),
              const SizedBox(
                height: 10,
              ),
              checkdata()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        minLines: 5,
        maxLines: 5,
        textAlignVertical: TextAlignVertical.top,
        controller: controller,
        style: const TextStyle(fontSize: kDefaultFont),
        decoration: InputDecoration(
          // labelText: 'กรอก QR-code id ที่ระบุไว้กับสถานที่ ',
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kTrushColor)),
          suffix: const Text(''),
        ),
      ),
    );
  }

  showAlertDialogWorning(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("ตกลง"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        // Get.offAll(() => WidgetBarItem(
        //     currentPage: 3, roleUser: controller.userModels.last.role));
        // Get.offAll(() => const SettingCheckinApp());
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("แจ้งเตือน !!"),
      content:
          const Text("ไม่สามารถบันทึกภาพได้ เนื่องจากไม่มีข้อมูล Qr-code id"),
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

  showAlertDialogok(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("ตกลง"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        controller.text = '';
        Permission.photos;
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("บันทึกสำเร็จ !!"),
      content: const Text("บันทึกภาพ Qr-code สำเร็จ"),
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

  Widget checkdata() {
    if (controller.text.isEmpty) {
      return GestureDetector(
        child: Container(
          // width: 120,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.green,
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'สร้าง',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: kDefaultFont,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        onTap: () {
          setState(() {});
        },
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: Container(
              width: 120,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.green,
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'สร้าง',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: kDefaultFont,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onTap: () {
              setState(() {});
            },
          ),
          GestureDetector(
            child: Container(
              width: 120,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.blueGrey,
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'บันทึกภาพ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: kDefaultFont,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onTap: () {
              if (controller.text.isNotEmpty) {
                String imagename = controller.text.replaceAll(' ', '');
                takeScreenShot(imagename);
              } else {
                showAlertDialogWorning(context);
              }
            },
          ),
        ],
      );
    }
  }
}
