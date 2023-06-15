import 'package:checkinapp/blocs/todo_list/todo_list_bloc.dart';
import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/states/home.dart';
import 'package:checkinapp/states/states_remark.dart';
// import 'package:checkinapp/states/todos_page/search_and_filter_todo.dart';
import 'package:checkinapp/states/todos_page/show_todos.dart';
import 'package:checkinapp/utility/app_controller.dart';
import 'package:checkinapp/utility/app_service.dart';
import 'package:checkinapp/widgets/widget_barbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({
    Key? key,
    required this.factoryModel,
  }) : super(key: key);

  final FactoryModel factoryModel;

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final _auth = FirebaseAuth.instance.currentUser;
  AppController controller = Get.put(AppController());

  loadData() async {
    await AppService().readUserModel();
    await AppService().CheckTodoResultModel(
        widget.factoryModel.id, DateFormat('yyyyMMdd').format(DateTime.now()));
    if (controller.checktodoresultModels.last.result != 0) {
      await AppService().readTodoResultModel('id${widget.factoryModel.id}',
          DateFormat('yyyyMMdd').format(DateTime.now()));

      await loadDatafinishtodo();
    }
    AppService().readCalendarallEventModel2(user!.uid);
  }

  loadDatafinishtodo() {
    if (controller.todoresultModels.last.uidCheck == _auth!.uid &&
        widget.factoryModel.id == controller.todoresultModels.last.checkinid) {
      if (controller.todoresultModels.last.finishtodo.isNotEmpty) {
        for (var i = 0;
            i < controller.todoresultModels.last.finishtodo.length;
            i++) {
          if (controller.todoresultModels.last.finishtodo[i] == true) {
            context.read<TodoListBloc>().add(ToggleTodoEvent('$i'));
          }
        }
      }
    }
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
          automaticallyImplyLeading: true,
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
                onPressed: () async {
                  loadData();
                  Get.offAll(() => WidgetBarItem(
                      currentPage: 1,
                      roleUser: controller.userModels.last.role));
                },
                // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          // leading: <Widget>[
          //   IconButton(
          //     icon: const Icon(
          //       Icons.east_outlined, //save_outlined done_outline_rounded
          //       size: 30,
          //       color: Colors.white,
          //     ),
          //     onPressed: () async {
          //       context .read<TodoListBloc>().add(SaveTodoEvent(widget.factoryModel.id));
          //       // loadData();
          //       // await AppService().readFileUpload(widget.factoryModel.id);
          //       // await Get.offAll(() => AddItem(factoryModel: widget.factoryModel));
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) =>
          //                   AddItem(factoryModel: widget.factoryModel)));
          //       // await showAlertDialog(context);
          //     },
          //   )
          // ],
        ),
        body: SingleChildScrollView(
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
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        savetodo(context);
                      },
                      child: TextButton(
                        onPressed: () async {
                          savetodo(context);
                        },
                        child: const Text(
                          'บันทึกเวลาเข้า',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void savetodo(BuildContext context) {
    context.read<TodoListBloc>().add(SaveTodoEvent(widget.factoryModel.id));
    // loadData();
    // await AppService().readFileUpload(widget.factoryModel.id);
    // await Get.offAll(() => AddItem(factoryModel: widget.factoryModel));

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddItem(factoryModel: widget.factoryModel)));
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
