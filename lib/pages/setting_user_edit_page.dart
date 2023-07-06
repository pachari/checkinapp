// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/userlist_model.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_snackbar.dart';
import 'package:checkinapp/widgets/widget_barbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class UserEditApp extends StatefulWidget {
  const UserEditApp({super.key, required this.userlistModels});
  final UserListModel userlistModels;

  @override
  State<UserEditApp> createState() => _UserEditAppState();
}

class _UserEditAppState extends State<UserEditApp> {
  AppController controller = Get.put(AppController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final List<String> _typeUser = ['maid', 'security', 'admin'];
  String? _selectVal = "";
  final List<String> _typeQuestion = [
    // 'ชุดคำถามที่ 1 (ชื่ออาคาร)',
    // 'ชุดคำถามที่ 2 (security)',
    // 'ชุดคำถามที่ 3 (แม่บ้าน)',
    // 'ชุดคำถามที่ 4 (ป้าเหมียว)',
    // 'ชุดคำถามที่ 5 (พ่อบ้าน)',
  ];
  String? _selectValQuestion = "";

  final List<String> _myList = [];
  final TextEditingController _myController = TextEditingController();
  String _inputList = "";

  Future<void> setData() async {
    setState(() {
      _inputList = "";
      _myList.clear();
    });
  }

  setSum() {
    for (int i = 0; i < _myList.length; i++) {
      if (i == 0) {
        _inputList = _myList[i];
      } else {
        _inputList = "$_inputList , ${_myList[i]}";
      }
    }
  }

  void loadData() {
    // role
    switch (widget.userlistModels.role) {
      case 'admin':
        _selectVal = _typeUser[2];
        break;
      case 'maid':
        _selectVal = _typeUser[0];
        break;
      case 'security':
        _selectVal = _typeUser[1];
        break;
      default:
        _selectVal = _typeUser[0];
        break;
    }

    // todo
    if (widget.userlistModels.todo.isNotEmpty) {
      for (int i = 0; i < widget.userlistModels.todo.length; i++) {
        if (i == 0) {
          _inputList = widget.userlistModels.todo[i];
        } else {
          _inputList = "$_inputList / ${widget.userlistModels.todo[i]}";
        }
      }
    }
    if (controller.factoryAllModels.isNotEmpty) {
      //group typeid
      int checkid = 0;
      for (var i = 0; i < controller.factoryAllModels.length; i++) {
        if (controller.factoryAllModels[i].typeid != checkid) {
          _typeQuestion
              .add('ชุดคำถามที่ ${controller.factoryAllModels[i].typeid}');
          checkid = controller.factoryAllModels[i].typeid;
        }
      }
      // set ddl typeid
      switch (widget.userlistModels.typeworkid + 1) {
        case 1:
          _selectValQuestion = _typeQuestion[0];
          break;
        case 2:
          _selectValQuestion = _typeQuestion[1];
          break;
        case 3:
          _selectValQuestion = _typeQuestion[2];
          break;
        case 4:
          _selectValQuestion = _typeQuestion[3];
          break;
        case 5:
          _selectValQuestion = _typeQuestion[4];
          break;
        default:
          _selectValQuestion = _typeQuestion[0];
          break;
      }
    } 
    // else {
    //   AppService().readInfoFactoryAll();
    // }
  }

  @override
  void initState() {
    super.initState();
    loadData();
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
        backgroundColor: kTabsColor,
        title: const Text(
          "แก้ไขข้อมูลผู้ใช้งาน",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kDefaultFont,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: kBackgroundColor,
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
                  buildMenuOption(
                      context,
                      'ชื่อ-สกุล',
                      usernameController,
                      FontAwesomeIcons.circleUser,
                      10.0,
                      widget.userlistModels.name),
                  // buildMenuOption(
                  //     context,
                  //     'Email address',
                  //     emailController,
                  //     FontAwesomeIcons.envelope,
                  //     10.0,
                  //     widget.userlistModels.email),
                  // buildMenuOption(context, 'Password', passwordController,
                  //     FontAwesomeIcons.eyeSlash, 10.0, ''),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "ประเภทของผู้ใช้งาน",
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
                    value: _selectVal,
                    items: _typeUser
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectVal = value;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: kPrimaryColor,
                    ),
                    dropdownColor: Colors.deepPurple.shade50,
                  ),
                  const Divider(
                    height: 30,
                    thickness: 1,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "ชุดคำถาม",
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
                        FontAwesomeIcons.fileLines,
                        color: kPrimaryColor,
                        size: kDefaultFont,
                      ),
                    ),
                    value: _selectValQuestion,
                    items: _typeQuestion
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectValQuestion = value;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: kPrimaryColor,
                    ),
                    dropdownColor: Colors.deepPurple.shade50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          trailing: const Icon(
                            FontAwesomeIcons.circleXmark,
                            color: Colors.red,
                            size: kDefaultFont,
                          ),
                          onTap: () {
                            showAlertDialogCancel(context);
                          },
                          dense: true,
                        ),
                        SizedBox(height: 150, child: addArraytodo()),
                        TextField(
                          controller: _myController,
                          decoration: const InputDecoration(
                            labelText: 'กรอกรายการคำตอบ',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            prefixIcon: Icon(
                              FontAwesomeIcons.fileCirclePlus,
                              color: kPrimaryColor,
                              size: kDefaultFont,
                            ),
                          ),
                          onSubmitted: (text) {
                            setState(() {
                              _myList.add(text);
                              setSum();
                              _myController.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
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
                onTap: () {
                  Checkdata(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addArraytodo() {
    return _inputList.isNotEmpty
        ? RefreshIndicator(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Text(
                        _inputList,
                        style: const TextStyle(fontSize: kDefaultFont),
                      ),
                    ],
                  );
                },
              ),
            ),
            onRefresh: () => setData(),
          )
        : const Text(
            "",
            style: TextStyle(fontSize: kDefaultFont),
          );
  }

  Future<void> Checkdata(context) async {
    if (emailController.text.isEmpty || usernameController.text.isEmpty) {
      AppSnackBar(title: 'SingIn Failure', massage: 'Please Fill in Data ')
          .errorSnackBar();
    } else if (passwordController.text.isNotEmpty &&
            passwordController.text.length < 6 ||
        emailController.text.length < 6 ||
        usernameController.text.length < 6) {
      AppSnackBar(
              title: 'SingIn Failure', massage: 'Please Check Data length > 6')
          .errorSnackBar();
    } else {
      UpdateFB();
    }
  }

  GestureDetector buildMenuOption(
      BuildContext context, title, controller, icon, top, val) {
    if (controller != '') {
      controller.text = val;
    }
    return GestureDetector(
      onTap: () {},
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

  Future<void> UpdateFB() async {
    String email = emailController.text.trim();
    // String newPassword = passwordController.text.trim();
    String username = usernameController.text.trim();
    List arryQT = _selectValQuestion!.split(" ");

    // final user = FirebaseAuth.instance.currentUser;
    // if (user != null ) {
    //   if (email.isNotEmpty && newPassword.isNotEmpty) {
    //     await user.updateEmail(email);
    //     await user.updatePassword(newPassword);
    //   } else {
    //     await user.updateEmail(email);
    //   }
    // }
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.userlistModels.uid)
        .update({
      "email": email,
      "name": username,
      "role": _selectVal,
      "typeid": int.parse(arryQT[1]),
      "todo": _myList,
    });
    showAlertDialog(context);
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("ตกลง"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Get.offAll(() => WidgetBarItem(
            currentPage: 2, roleUser: controller.userModels.last.role));
        // Get.offAll(() => const LoginApp());
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

  showAlertDialogCancel(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("ตกลง"),
      onPressed: () {
        setData();
        addArraytodo();
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
}
