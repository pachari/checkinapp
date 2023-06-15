import 'dart:io';

// import 'package:checkinapp/states/states_confirm_checkin.dart';
import 'package:checkinapp/states/states_todolist.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/widgets/widget_barbutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/factory_model.dart';

class QRcodeReader extends StatefulWidget {
  const QRcodeReader({
    Key? key,
    required this.factoryModel,
  }) : super(key: key);

  final FactoryModel factoryModel;

  @override
  State<QRcodeReader> createState() => _QRcodeReaderState();
}

class _QRcodeReaderState extends State<QRcodeReader> {
  AppController controller = Get.put(AppController());

  final qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? barcode;
  QRViewController? controllers;

  @override
  void dispose() {
    controllers?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controllers?.pauseCamera();
    }
    controllers!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: false,
            backgroundColor: kPrimaryColor,
            title: const Text(
              "QR-code Reader",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              buildQeView(context),
              Positioned(
                bottom: 10,
                child: buildResult(),
              ),
              Positioned(
                top: 10,
                child: buildControlButton(),
              )
            ],
          )),
    );
  }

  Widget buildQeView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controllers) {
    setState(() {
      this.controllers = controllers;
    });

    controllers.scannedDataStream.listen((barcode) async {
      if (widget.factoryModel.qr == barcode.code) {
        // Get.offAll( ConfirmCheckIn(factoryModel: widget.factoryModel,));
        // Get.offAll(ToDoList(
        //   factoryModel: widget.factoryModel,
        // ));
        // Navigator.of(context, rootNavigator: true).pop();
        Get.offAll(ToDoList(
          factoryModel: widget.factoryModel,
        ));

        setState(() {
          this.barcode = barcode;
        });
      } else {
        await showAlertDialog(context);
        // AppDialog(context: context).normalDialog(
        //     title:
        //         "You can't scan the qrcode because the data is invalid. Please select the checkpoint again.",
        //     content: 'Warning!');
        // Navigator.of(context, rootNavigator: true).pop();
        // await Get.offAll(() => WidgetBarItem(
        //     currentPage: 1, roleUser: controller.userModels.last.role));
      }
    });
  }

  Widget buildResult() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 20,
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(8)),
        child: Text(
          barcode != null ? 'Result: ${barcode!.code}' : 'Sacn a code!',
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildControlButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: FutureBuilder<bool?>(
                future: controllers?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(
                        snapshot.data! ? Icons.flash_on : Icons.flash_off);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
                await controllers?.toggleFlash();
                setState(
                  () {},
                );
              },
            ),
            IconButton(
              icon: FutureBuilder(
                future: controllers?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return const Icon(Icons.switch_camera);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
                await controllers?.flipCamera();
                setState(
                  () {},
                );
              },
            )
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        // Navigator.of(context, rootNavigator: true).pop();
        Get.offAll(() => WidgetBarItem(
            currentPage: 1, roleUser: controller.userModels.last.role));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Warning!"),
      content: const Text(
          "You can't scan the qrcode because the data is invalid. Please select the checkpoint again."),
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
