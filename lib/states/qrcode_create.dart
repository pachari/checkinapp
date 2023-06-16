// import 'package:checkinapp/componants/background.dart';
import 'package:checkinapp/componants/constants.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRcodeCreate extends StatefulWidget {
  const QRcodeCreate({super.key});

  @override
  State<QRcodeCreate> createState() => _QRcodeCreateState();
}

class _QRcodeCreateState extends State<QRcodeCreate> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
         appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: const Text(
            "QR-code Create",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImageView(
                  data: controller.text,
                  size: 200,
                ),
                const SizedBox(
                  height: 40,
                ),
                buildTextField(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      decoration: InputDecoration(
          hintText: 'Enter the data',
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: kPrimaryColor),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: kTrushColor)),
          suffixIcon: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(
              Icons.done,
              size: 30,
              color: Colors.green,
            ),
            onPressed: () => setState(() {}),
          )),
    );
  }
}
