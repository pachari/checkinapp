import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:checkinapp/blocs/active_todo_count/active_todo_count_bloc.dart';
import 'package:checkinapp/blocs/blocs.dart';
import 'package:checkinapp/models/todo_model.dart';


class TodoHeader extends StatelessWidget {
  const TodoHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // const Text(
        //   'Add To-Do',
        //   style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),
        // ),
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            final int activeTodoCount = state.todos
                .where((Todo todo) => !todo.completed)
                .toList()
                .length;

            context
                .read<ActiveTodoCountBloc>()
                .add(CalculateActiveTodoCountEvent(activeTodoCount));
          },
          child: BlocBuilder<ActiveTodoCountBloc, ActiveTodoCountState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${state.activeTodoCount} items pending',
                  style: const TextStyle(fontSize: 15.0, color: Colors.redAccent),
                ),
              );
            },
          ),
        ),
        // Text(
        //   '${context.watch<ActiveTodoCountCubit>().state.activeTodoCount} items left',
        //   style: TextStyle(fontSize: 20.0, color: Colors.redAccent),
        // ),
      ],
    );
  }
}
