// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print, unused_element

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/pages/login_page.dart';
import 'package:checkinapp/pages/print_page.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_service.dart';
import 'package:checkinapp/utility/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

class ExportCheckInApp extends StatefulWidget {
  const ExportCheckInApp({super.key});

  @override
  State<ExportCheckInApp> createState() => _ExportCheckInAppState();
}

class _ExportCheckInAppState extends State<ExportCheckInApp> {
  AppController controller = Get.put(AppController());
  TextEditingController emailController = TextEditingController();
  TextEditingController strdateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();

  final List<String> _typeExport = ['PDF', 'CSV', 'XLS'];
    String _selecttypeExport = "";

  final List<String> _ListUser = [];
  String _selectValListUser = "";
  int _selectIndexListUser = 0;

  void loaddata() {
    //users all
    for (var i = 0; i < controller.userlistModels.length; i++) {
      _ListUser.add(controller.userlistModels[i].name);
    }
  }

  @override
  void initState() {
    super.initState();
    loaddata();
    _selectValListUser = _ListUser[0];
    _selecttypeExport = _typeExport[0];
    strdateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());//"2023-06-16";
    enddateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());//"2023-06-30";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: kPrimaryColor,
        title: const Text(
          "Exports รายการเช็คอิน",
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
              const SizedBox(
                height: 10,
              ),
              Column(
                children: <Widget>[
                  // buildInputOption(context, 'ชื่อ-สกุล', usernameController,
                  //     FontAwesomeIcons.user, 10.0),
                  // buildInputOption(context, 'อีเมล', emailController,
                  //     FontAwesomeIcons.envelope, 10.0),
                  // buildInputOption(context, 'รหัสผ่าน', passwordController,
                  //     FontAwesomeIcons.eye, 10.0),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // DropdownButtonFormField(
                  //   decoration: InputDecoration(
                  //     labelText: "ประเภทของพนักงาน",
                  //     enabledBorder: const OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //     focusedBorder: const OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //     filled: true,
                  //     fillColor: Colors.deepPurple.shade50,
                  //     prefixIcon: const Icon(
                  //       FontAwesomeIcons.tags,
                  //       color: kPrimaryColor,
                  //       size: kDefaultFont,
                  //     ),
                  //   ),
                  //   value: _selectVal,
                  //   items: _typeUser
                  //       .map((e) => DropdownMenuItem(
                  //             value: e,
                  //             child: Text(e),
                  //           ))
                  //       .toList(),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _selectVal = value;
                  //     });
                  //   },
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down_rounded,
                  //     color: kPrimaryColor,
                  //   ),
                  //   dropdownColor: Colors.deepPurple.shade50,
                  // ),
                  const SizedBox(
                    height: 15,
                  ),
                  buildInpotDropdown(context),
                  const SizedBox(
                    height: 15,
                  ),
                  buildInputDate(context, 'วันเริ่มต้น', strdateController),
                  const SizedBox(
                    height: 15,
                  ),
                  buildInputDate(context, 'วันสิ้นสุด', enddateController),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     buildInpotRadio(context, 'PDF'),
              //     // buildInpotRadio(context, 'CSV'),
              //     // buildInpotRadio(context, 'XLS'),
              //   ],
              // ),
              const Center(
                child: Text('Click on the Export button below'),
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
                      'Export',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: kDefaultFont,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                onTap: () {
                  Savedata(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Savedata(BuildContext context) async {
    int a = AppService().daysBetween(DateTime.parse(strdateController.text),
        DateTime.parse(enddateController.text));

    if (a > 0) {
      // _onLoading();
      await AppService().readTodoResultforPrintModel(
          controller.userlistModels[_selectIndexListUser].uid,
          strdateController.text,
          enddateController.text,
          controller.userlistModels[_selectIndexListUser].email,
          controller.userlistModels[_selectIndexListUser].todo);
      // Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PrintApp()),
      );
    } else {
      AppSnackBar(
              title: 'Load Data Failure',
              massage: 'Please Check Start Date or end Date')
          .errorSnackBar();
    }
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: SizedBox(
            height: 70,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Loading"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
      // _login();
    });
  }

  GestureDetector buildInputOption(
      BuildContext context, title, controller, icon, top) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => tabs),
        // );
      },
      child: Container(
        margin: EdgeInsets.only(top: top),
        child: TextFormField(
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

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text(
        "ตกลง",
      ),
      onPressed: () {
        Get.offAll(() => const LoginAndSignup());
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("ลงทะเบียนผู้ใช้งาน"),
      content: const Text("บันทึกสำเร็จ!!"),
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

  showAlertDialogCancel(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("ตกลง"),
      onPressed: () {
        // setData();
        // addArraytodo();
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget cancleButton = TextButton(
      child: const Text("ยกเลิก"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("แจ้งเตือน ลบข้อมูล !!"),
      content: const Text("คุณต้องการลบข้อมูลรายการคำตอบทั้งหมดใช่หรือไม่?"),
      actions: [
        cancleButton,
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

  Widget buildInputDate(BuildContext context, title, controller) {
    return TextField(
      controller: controller, //editing controller of this TextField
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.calendar_today), //icon of text field
        labelText: title, //label text of field
      ),
      readOnly: true, //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            controller.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          print("Date is not selected");
        }
      },
    );
  }

  Widget buildInpotRadio(BuildContext context, val) {
    return Expanded(
      child: ListTile(
        leading: Radio<String>(
          value: val,
          groupValue: _selecttypeExport,
          onChanged: (value) {
            setState(() {
              _selecttypeExport = value!;
            });
          },
        ),
        title: Text(
          val,
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }

  Widget buildInpotDropdown(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: "ชื่อพนักงาน",
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        prefixIcon: const Icon(
          FontAwesomeIcons.tags,
          color: kPrimaryColor,
          size: kDefaultFont,
        ),
      ),
      value: _selectValListUser,
      items: _ListUser.map((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          )).toList(),
      onChanged: (value) {
        setState(() {
          _selectValListUser = value!;
          _selectIndexListUser = _ListUser.indexOf(value);
        });
      },
      icon: const Icon(
        Icons.arrow_drop_down_rounded,
        color: kPrimaryColor,
      ),
      dropdownColor: Colors.deepPurple.shade50,
    );
  }
}
