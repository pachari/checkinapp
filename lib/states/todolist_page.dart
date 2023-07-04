// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:checkinapp/blocs/todo_list/todo_list_bloc.dart';
import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/models/fileupload_model.dart';
import 'package:checkinapp/states/bk_home.dart';
import 'package:checkinapp/states/todos_page/show_todos.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_service.dart';
import 'package:checkinapp/utility/app_snackbar.dart';
import 'package:checkinapp/widgets/widget_barbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({
    Key? key,
    required this.factoryModel,
    required this.todoid,
  }) : super(key: key);

  final FactoryModel factoryModel;
  final String todoid;

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // final _auth = FirebaseAuth.instance.currentUser;
  AppController controller = Get.put(AppController());
  GlobalKey<FormState> key = GlobalKey();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerRemark = TextEditingController();

  loadData() async {
    // await AppService().readUserModel();
    await AppService().CheckTodoResultModel(widget.factoryModel.id,
        DateFormat('yyyyMMdd').format(DateTime.now()), widget.todoid);
    if (controller.checktodoresultModels.last.result != 0) {
      await AppService().readTodoResultModel('${widget.factoryModel.id}',
          DateFormat('yyyyMMdd').format(DateTime.now()));
      loadDatafinishtodo();
    }
    // loadDatafileupload();
    AppService().readCalendarallEventModel2(user!.uid,DateTime.now());
  }

  loadDatafinishtodo() {
    // if (controller.todoresultModels.isNotEmpty) {
    //   if (controller.todoresultModels.last.uidCheck == _auth!.uid &&
    //       widget.factoryModel.id ==
    //           controller.todoresultModels.last.checkinid) {
    //     if (controller.todoresultModels.last.finishtodo.isNotEmpty) {
    //       for (var i = 0;
    //           i < controller.todoresultModels.last.finishtodo.length;
    //           i++) {
    //         if (controller.todoresultModels.last.finishtodo[i] == true) {
    //           context.read<TodoListBloc>().add(ToggleTodoEvent('$i'));
    //         }
    //       }
    //     }
    //   }
    // }
    for (var i = 0; i < controller.userModels.last.todo.length; i++) {
      context.read<TodoListBloc>().add(ClearTodoEvent('$i'));
    }
  }

  Future loadDatafileupload() async {
    if (controller.fileuploadModels.isNotEmpty) {
      imageUrl = controller.fileuploadModels.last.image;
      _controllerName.text = controller.fileuploadModels.last.name;
      _controllerRemark.text = controller.fileuploadModels.last.remark;
    }
  }

  String toDate = DateFormat('yyyyMMdd').format(DateTime.now());
  final CollectionReference _reference = FirebaseFirestore.instance
      .collection('todolist')
      .doc(user?.uid)
      .collection(DateFormat('yyyyMMdd').format(DateTime.now()));
  String imageUrl = '';
  XFile? image;
  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: const Text(
            "To-Do list",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: ()  {
                  loadDatafinishtodo();
                  Get.offAll(() => WidgetBarItem(
                      currentPage: 1,
                      roleUser: controller.userModels.last.role));
                },
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.done_outline_rounded, //save_outlined done_outline_rounded
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                context.read<TodoListBloc>().add(SaveTodoEvent(widget.todoid));
                uploadimage();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
           color:kBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // TodoHeader(),
                    // SizedBox(height: 5),
                    // CreateTodo(),
                    // const SizedBox(height: 2),
                    // const SearchAndFilterTodo(),
                    const SizedBox(height: 2),
                    const ShowTodos(),
                    widgetimage(),
                    // buttonsave()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  widgetimage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(
              //       top: 15, left: 8, right: 8, bottom: 0),
              //   child: TextFormField(
              //     controller: _controllerName,
              //     decoration: const InputDecoration(
              //       contentPadding: EdgeInsets.symmetric(
              //           vertical: 15.0, horizontal: 10.0),
              //       labelText: 'หัวข้อ',
              //       // hintText: 'Enter the name of the item'
              //     ),
              //     validator: (String? value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter the item topic';
              //       }
              //       return null;
              //     },
              //     maxLines: 2,
              //     minLines: 1,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: TextFormField(
                  controller: _controllerRemark,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
                    labelText: 'รายละเอียด',
                    // hintText: 'Enter the remark of the item'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'เนื่องจากมีการแนบไฟล์รูปภาพ กรุณากรอกรายละเอียดเพิ่มเติม';
                    }
                    return null;
                  },
                  maxLines: 15,
                  minLines: 1,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child:
                      selectimage()), //image != null ? selectimage() : getimage()),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 70, right: 70, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    myAlert();
                  },
                  child: const Text('แนบไฟล์ภาพ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buttonsave() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        onPressed: () async {
          context.read<TodoListBloc>().add(SaveTodoEvent(widget.todoid));
          uploadimage();
        },
        child: TextButton(
          onPressed: () async {
            context.read<TodoListBloc>().add(SaveTodoEvent(widget.todoid));
            // _reference.doc("id${widget.factoryModel.id}").update({
            //   "timestampOut": DateTime.now(),
            // });
            uploadimage();
          },
          child: const Text(
            'บันทึก',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ));
  }

  getimage() {
    if (imageUrl.isNotEmpty) {
      return DottedBorder(
        color: Colors.grey,
        dashPattern: const [9, 5],
        strokeWidth: 2,
        strokeCap: StrokeCap.round,
        borderType: BorderType.RRect,
        radius: const Radius.circular(kDefaultCircular),
        child: Container(
            height: 280,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: 250,
            )),
      );
    }
  }

  selectimage() {
    if (image != null) {
      return DottedBorder(
        color: Colors.grey,
        dashPattern: const [9, 5],
        strokeWidth: 2,
        strokeCap: StrokeCap.round,
        borderType: BorderType.RRect,
        radius: const Radius.circular(kDefaultCircular),
        child: Container(
            height: 280,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  //to show image, you type like this.
                  File(image!.path),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                ),
              ),
            )),
      );
    }
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text(
              'เลือกที่อยู่ของไฟล์รูปภาพ',
              style: TextStyle(
                fontSize: kDefaultFont,
              ),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.orangeAccent,
                        ),
                        Center(
                          child: Text(
                            'แกลลอรี่',
                            style: TextStyle(color: Colors.orangeAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.camera, color: Colors.blue),
                        Text(
                          'กล้อง',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> uploadimage() async {
    if (image == null) {
      showAlertDialog(context); //return;
    } else if (key.currentState!.validate()) {
      showAlertDialog(context);
      //Import dart:core
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      //Get a reference to storage root
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      //Create a reference for the image to be stored
      Reference referenceImageToUpload = referenceDirImages
          .child('${user?.uid}_${toDate}_${widget.factoryModel.id}');
      //Handle errors/success
      try {
        //Store the file
        await referenceImageToUpload.putFile(File(image!.path));
        //Success: get the download URL
        imageUrl = await referenceImageToUpload.getDownloadURL();
      } catch (error) {
        //Some error occurred
      }
      String itemName = _controllerName.text;
      String itemRemark = _controllerRemark.text;
      //Create a Map of data
      Map<String, String> dataToSend = {
        'name': '${user?.uid}_${toDate}_${widget.factoryModel.id}', //itemName,
        'remark': itemRemark,
        'image': imageUrl,
        'todoid': widget.todoid
      };
      //set data service
      FileUploads fileuploadModels = FileUploads(
          name: itemName,
          remark: itemRemark,
          image: imageUrl,
          uid: user!.uid,
          factoryid: '${widget.factoryModel.id}',
          todoid: widget.todoid);
      controller.fileuploadModels.add(fileuploadModels);

      // await todolists
      //     .doc(user?.uid)
      //     .collection(formattedDate)
      //     .doc("id${event.id}")
      //     .update({
      //   "finishtodo": finishtodo,
      //   // "timestampIn": DateTime.now(),
      //   "timestampOut": DateTime.now(),
      //   // "uidCheck": user?.uid,
      //   // "checkinid": event.id,
      // });
      //Add a new item
      final f = await _reference
          .doc(widget.todoid)
          .collection('fileupload')
          .add(dataToSend);
      await _reference.doc(widget.todoid).update({
        "image": f.id,
      });
    } else {
      AppSnackBar(
              title: 'Submit Failure!',
              massage: 'Please enter the item topic or remark')
          .errorSnackBar();
    }
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("ตกลง"),
      onPressed: () {
        // loadData();
        // AppService().ClearActivetodo(context);

        // Navigator.of(context, rootNavigator: true).pop();
        Get.offAll(() => WidgetBarItem(
            currentPage: 2, roleUser: controller.userModels.last.role));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("บันทึกรายการเช็คอิน"),
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
  // showAlertDialog(BuildContext context) {
  //   // set up the button
  //   Widget okButton = TextButton(
  //     child: const Text("OK"),
  //     onPressed: () {
  //       // Get.offAll(() => WidgetBarItem( currentPage: 0, roleUser: controller.userModels.last.role));
  //       // Get.offAll(() => const ImageUploads()); //ImageUploads
  //       Get.offAll(() => AddItem(factoryModel: widget.factoryModel));
  //       loadData();
  //     },
  //   );
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: const Text("To-Do list"),
  //     content: const Text("Saved successfully!!."),
  //     actions: [
  //       okButton,
  //     ],
  //   );
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}

// GetX<AppController> todoUser() {
//   return GetX(
//       init: AppController(),
//       builder: (appController) {
//         print('UserModel --> ${appController.userModels.length}');
//         return Scaffold(
//             appBar: AppBar(
//               title: const WidgetText(
//                 data: 'ToDoList',
//               ),
//             ),
//             body: appController.userModels.isEmpty
//                 ? const SizedBox()
//                 : ListView.builder(
//                     itemCount: appController.userModels.last.todo.length,
//                     itemBuilder: (context, index) => CheckboxListTile(
//                       value: false,
//                       onChanged: (value) {},
//                       title: WidgetText(
//                         data: appController.userModels.last.todo[index],
//                       ),
//                     ),
//                   ));
//       });
// }
// }
