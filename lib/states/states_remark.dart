// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'dart:io';

import 'package:checkinapp/blocs/todo_list/todo_list_bloc.dart';
import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/models/fileupload_model.dart';
import 'package:checkinapp/states/bk_home.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_service.dart';
// import 'package:checkinapp/utility/app_service.dart';
import 'package:checkinapp/utility/app_snackbar.dart';
import 'package:checkinapp/widgets/widget_barbutton.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key, required this.factoryModel}) : super(key: key);
  final FactoryModel factoryModel;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerRemark = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  AppController controller = Get.put(AppController());
  String toDate = DateFormat('yyyyMMdd').format(DateTime.now());

  ///todolist/S97KxIE9C7YHwUnlnB5rQaXHHrd2/20230608/id10
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

  Future loadData() async {
    if (controller.fileuploadModels.isNotEmpty) {
      imageUrl = controller.fileuploadModels.last.image;
      _controllerName.text = controller.fileuploadModels.last.name;
      _controllerRemark.text = controller.fileuploadModels.last.remark;
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: kPrimaryColor,
        title: const Text(
          "รายการกิจกรรม",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: DottedBorder(
                    color: Colors.grey,
                    dashPattern: const [9, 5],
                    strokeWidth: 2,
                    strokeCap: StrokeCap.round,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(kDefaultCircular),
                    child: Container(
                        height: 290,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        child: image != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    //to show image, you type like this.
                                    File(image!.path),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                  ),
                                ),
                              )
                            : Center(
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 300,
                                      )
                                    : const Text(
                                        "ไม่มีภาพแนบ",//No Image
                                        style:
                                            TextStyle(fontSize: kDefaultFont,color: Colors.grey),
                                      ),
                              )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 50, right: 50, bottom: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      myAlert();
                    },
                    child: const Text('เลือกรูปภาพ'),
                  ),
                ),
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerRemark,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 10.0),
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
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      await uploadimage();
                    },
                    child: TextButton(
                      onPressed: () async {
                        // context .read<TodoListBloc>().add(SaveTodoEvent(widget.factoryModel.id));
                        await _reference
                            .doc("id${widget.factoryModel.id}")
                            .update({
                          "timestampOut": DateTime.now(),
                        });
                        await uploadimage();
                      },
                      child: const Text(
                       'บันทึกเวลาออก',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadimage() async {
    if (image == null) {
      showAlertDialog(context); //return;
    } else if (key.currentState!.validate()) {
      
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
        'name': itemName,
        'remark': itemRemark,
        'image': imageUrl,
      };
      //set data service
      FileUploads fileuploadModels = FileUploads(
          name: itemName,
          remark: itemRemark,
          image: imageUrl,
          uid: user!.uid,
          factoryid: '${widget.factoryModel.id}');
      controller.fileuploadModels.add(fileuploadModels);
      //Add a new item
      await _reference
          .doc('id${widget.factoryModel.id}')
          .collection('fileupload')
          .add(dataToSend);

      await showAlertDialog(context);
    } else {
      AppSnackBar(
              title: 'Submit Failure!',
              massage: 'Please enter the item topic or remark')
          .errorSnackBar();
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("ตกลง"),
      onPressed: ()  {
        AppService().ClearActivetodo(context);
        // loadDatafinishtodo();
        Navigator.of(context, rootNavigator: true).pop();
        Get.offAll(() => WidgetBarItem(
            currentPage: 1, roleUser: controller.userModels.last.role));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("แจ้งเตือน"),
      content: const Text("บันทึกรายการเช็คอิน สำเร็จ."),
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

  loadDatafinishtodo() {
    for (var i = 0;
        i < controller.todoresultModels.last.finishtodo.length;
        i++) {
      if (controller.todoresultModels.last.finishtodo[i] == true) {
        context.read<TodoListBloc>().add(ToggleTodoEvent('$i'));
      }
    }
  }
}
