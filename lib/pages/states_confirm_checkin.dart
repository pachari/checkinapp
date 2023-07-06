// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:checkinapp/models/checkinout_model.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/utility/app_controller.dart';
// import 'package:checkinapp/utility/app_dialog.dart';
// import 'package:checkinapp/utility/app_service.dart';
// import 'package:checkinapp/widgets/widget_barbutton.dart';
// import 'package:checkinapp/widgets/widget_button.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:checkinapp/widgets/widget_text.dart';
import 'package:get/get.dart';

class ConfirmCheckIn extends StatefulWidget {
  const ConfirmCheckIn({
    Key? key,
    required this.factoryModel,
  }) : super(key: key);

  final FactoryModel factoryModel;

  @override
  State<ConfirmCheckIn> createState() => _ConfirmCheckInState();
}

class _ConfirmCheckInState extends State<ConfirmCheckIn> {
  @override
  void initState() {
    super.initState();
    // AppService().readUserModel();
  }

  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WidgetText(
          data: 'รายการกิจกรรม',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: GetX(
            init: AppController(),
            builder: (appController) {
              return appController.userModels.isEmpty
                  ? const SizedBox()
                  : ListView.builder(
                      itemCount: appController.userModels.last.todo.length,
                      itemBuilder: (context, index) => CheckboxListTile(
                        value: false,
                        onChanged: (value) {},
                        title: WidgetText(
                          data: appController.userModels.last.todo[index],
                        ),
                      ),
                    );
            },),
      ),
    );
  }
}

  // Scaffold(
  //   appBar: AppBar(
  //     title: const WidgetText(
  //       data: 'Confirm Checkin',
  //     ),
  //   ),
  //   body:
  // Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     WidgetText(
  //       data: widget.factoryModel.title,
  //     ),
  //     WidgetText(
  //       data: widget.factoryModel.subtitle,
  //     ),
  //     WidgetText(
  //       data: dateTime.toString(),
  //     ),
  //     Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [

  //         // WidgetButton(
  //         //   label: 'Check in',
  //         //   pressFunc: () async {
  //         //     var user = FirebaseAuth.instance.currentUser;
  //         //     CheckOutModel checkOutModel = CheckOutModel(
  //         //         uidCheck: user!.uid,
  //         //         timestampIn: Timestamp.fromDate(dateTime));

  //         //     await FirebaseFirestore.instance
  //         //         .collection('checkin')
  //         //         .doc('id${widget.factoryModel.id}')
  //         //         .collection('todo')
  //         //         .doc()
  //         //         .set(checkOutModel.toMap())
  //         //         .then(
  //         //       (value) {
  //         //         AppDialog(context: context).normalDialog(
  //         //             title: 'Check in Success',
  //         //             firstAction: WidgetButton(
  //         //               label: 'Ok',
  //         //               pressFunc: () {
  //         //                 // Get.offAll(const ToDoList());
  //         //                 Get.offAll(const WidgetBarItem(
  //         //                   currentPage: 2,
  //         //                 ));
  //         //               },
  //         //             ));
  //         //       },
  //         //     );
  //         //   },
  //         // ),
  //         // WidgetButton(
  //         //   label: 'Cancel',
  //         //   pressFunc: () {
  //         //     Get.offAll(const WidgetBarItem(
  //         //       currentPage: 0,
  //         //     ));
  //         //   },
  //         // ),
  //       ],
  //     )
  //   ],
  // ),
  // );
  // }


