// import 'package:checkinapp/blocs/active_todo_count/active_todo_count_bloc.dart';
// import 'package:checkinapp/blocs/filtered_todos/filtered_todos_bloc.dart';
// import 'package:checkinapp/blocs/todo_filter/todo_filter_bloc.dart';
import 'package:checkinapp/blocs/todo_list/todo_list_bloc.dart';
// import 'package:checkinapp/blocs/todo_search/todo_search_bloc.dart';
import 'package:checkinapp/componants/constants.dart';
import 'package:checkinapp/models/factory_model.dart';
import 'package:checkinapp/states/todos_page/create_todo.dart';
import 'package:checkinapp/states/todos_page/header_todo.dart';
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
  AppController controller = Get.put(AppController());
  final _auth = FirebaseAuth.instance.currentUser;

  void loadData() async {
    await AppService().CheckTodoResultModel(widget.factoryModel.typeid,
        DateFormat('yyyyMMdd').format(DateTime.now()));
    if (controller.checktodoresultModels.last.result != 0) {
      await AppService().readTodoResultModel('id${widget.factoryModel.typeid}',
          DateFormat('yyyyMMdd').format(DateTime.now()));

      loadDatafinishtodo();
    }
  }

  loadDatafinishtodo() {
    if (controller.todoresultModels.last.uidCheck == _auth!.uid &&
        widget.factoryModel.typeid ==
            controller.todoresultModels.last.checkinid) {
      for (var i = 0;
          i < controller.todoresultModels.last.finishtodo.length;
          i++) {
        if (controller.todoresultModels.last.finishtodo[i] == true) {
          context.read<TodoListBloc>().add(ToggleTodoEvent('$i'));
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.save_outlined,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () async {
                context
                    .read<TodoListBloc>()
                    .add(SaveTodoEvent(widget.factoryModel.typeid));
                await showAlertDialog(context);
              },
            )
          ],
        ),
        body: const SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TodoHeader(),
                  SizedBox(height: 5),
                  CreateTodo(),
                  SizedBox(height: 2),
                  SizedBox(height: 2),
                  ShowTodos()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        // Get.offAll(() => const WidgetBarItem( currentPage: 0, ));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const WidgetBarItem(
                    currentPage: 0,
                  )),
        );
        loadData();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("To-Do list"),
      content: const Text("Saved successfully!!."),
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
