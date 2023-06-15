import 'package:checkinapp/componants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final TextEditingController newTodoController = TextEditingController();

  @override
  void dispose() {
    newTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: TextField(
        controller: newTodoController,
        decoration: InputDecoration(
          hintText: 'เพิ่มรายการ',
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(25.0),
              gapPadding: 1),
          prefixIcon: const Icon(
            Icons.add_card_rounded,
            color: kselectedItemColor,
          ),
        ),
        onSubmitted: (String? todoDesc) {
          if (todoDesc != null && todoDesc.trim().isNotEmpty) {
            context.read<TodoListBloc>().add(AddTodoEvent(todoDesc));
            newTodoController.clear();
          }
        },
      ),
    );
  }
}
