// import 'package:checkinapp/componants/background.dart';
// import 'package:checkinapp/states/todos_page/show_todos.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'create_todo.dart';
// import 'header_todo.dart';
// import 'package:checkinapp/componants/constants.dart';
// import 'package:checkinapp/blocs/todo_list/todo_list_bloc.dart';

// class TodosPage extends StatelessWidget {
//   final int _index;
//   const TodosPage(this._index, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: kPrimaryColor,
//           title: const Text(
//             "รายการกิจกรรม",
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Color.fromARGB(255, 255, 255, 255)),
//           ),
//           actions: <Widget>[
//             IconButton(
//               icon: const Icon(
//                 Icons.save_outlined,
//                 size: 30,
//                 color: Colors.white,
//               ),
//               onPressed: () async {
//                 context.read<TodoListBloc>().add(SaveTodoEvent(_index));
//                 await showAlertDialog(context);
//               },
//             )
//           ],
//         ),
//         body:  const Background(
//           child: SafeArea(
//             child: Padding(
//               padding:  EdgeInsets.symmetric(
//                 horizontal: 10,
//                 vertical: 10,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children:  [
//                   TodoHeader(),
//                   SizedBox(height: 5),
//                   CreateTodo(),
//                   SizedBox(height: 2),
//                   // SearchAndFilterTodo(),
//                   SizedBox(height: 2),
//                   ShowTodos(), //_index
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // body: SingleChildScrollView(
//         //   child: Padding(
//         //     padding: const EdgeInsets.symmetric(
//         //       horizontal: 10,
//         //       vertical: 10,
//         //     ),
//         //     child:
//         //         Column(mainAxisAlignment: MainAxisAlignment.start, children: [
//         //       // const TodoHeader(),
//         //       // const SizedBox(height: 5),
//         //       // const CreateTodo(),
//         //       // const SizedBox(height: 2),
//         //       // // SearchAndFilterTodo(),
//         //       // const SizedBox(height: 2),
//         //       // const ShowTodos(),
//         //     ]),
//         //   ),
//         // ),
//       ),
//     );
//   }

//   showAlertDialog(BuildContext context) {
//     // set up the button
//     Widget okButton = TextButton(
//       child: const Text("OK"),
//       onPressed: () {
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) => Launcher(9999),
//         //   ),
//         // );
//       },
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: const Text("To-Do list"),
//       content: const Text("Saved successfully!!."),
//       actions: [
//         okButton,
//       ],
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
