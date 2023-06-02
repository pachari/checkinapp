import 'package:checkinapp/componants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:checkinapp/blocs/blocs.dart';
import 'package:checkinapp/models/todo_model.dart';

class ShowTodos extends StatefulWidget {
  const ShowTodos({Key? key}) : super(key: key);

  @override
  State<ShowTodos> createState() => _ShowTodosState();
}

class _ShowTodosState extends State<ShowTodos> {
  List<Todo> setFilteredTodos(
    Filter filter,
    List<Todo> todos,
    String searchTerm,
  ) {
    List<Todo> filteredTodos;

    switch (filter) {
      case Filter.active:
        filteredTodos = todos.where((Todo todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        filteredTodos = todos.where((Todo todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todos;
        break;
    }

    if (searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos
          .where((Todo todo) =>
              todo.desc.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    return filteredTodos;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
              context.read<TodoFilterBloc>().state.filter,
              state.todos,
              context.read<TodoSearchBloc>().state.searchTerm,
            );
            context
                .read<FilteredTodosBloc>()
                .add(CalculateFilteredTodosEvent(filteredTodos));
          },
        ),
        BlocListener<TodoFilterBloc, TodoFilterState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
              state.filter,
              context.read<TodoListBloc>().state.todos,
              context.read<TodoSearchBloc>().state.searchTerm,
            );
            context
                .read<FilteredTodosBloc>()
                .add(CalculateFilteredTodosEvent(filteredTodos));
          },
        ),
        BlocListener<TodoSearchBloc, TodoSearchState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
              context.read<TodoFilterBloc>().state.filter,
              context.read<TodoListBloc>().state.todos,
              state.searchTerm,
            );
            context
                .read<FilteredTodosBloc>()
                .add(CalculateFilteredTodosEvent(filteredTodos));
          },
        ),
      ],
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: context.watch<FilteredTodosBloc>().state.filteredTodos.length, 
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(color: Colors.grey);
        },
        itemBuilder: (BuildContext context, int index) {
          return TodoItem(todo: context.watch<FilteredTodosBloc>().state.filteredTodos[index]); //cut shows delete
          // Dismissible(
          //   key: ValueKey(todos[index].id),
          // background: showBackground(0),
          // secondaryBackground: showBackground(1),
          // onDismissed: (_) {
          // context.read<TodoListBloc>().add(RemoveTodoEvent(todos[index]));
          // },
          // confirmDismiss: (_) {
          //   return showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: const Text('Are you sure?'),
          //         content: const Text('Do you really want to delete?'),
          //         actions: [
          //           TextButton(
          //             onPressed: () => Navigator.pop(context, false),
          //             child: const Text('NO'),
          //           ),
          //           TextButton(
          //             onPressed: () => Navigator.pop(context, true),
          //             child: const Text('YES'),
          //           ),
          //         ],
          //       );
          //     },
          //   );
          // },
          // child: TodoItem(todo: todos[index]),
          // );
        },
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: ListTile(
        onTap: () {},
        leading: Checkbox(
          shape: const CircleBorder(),
          checkColor: Colors.white, 
          activeColor: Colors.green,
          value: todo.completed,
          onChanged: (bool? checked) {
            context.read<TodoListBloc>().add(ToggleTodoEvent(todo.id));
          },
        ),
        title: Text(
          todo.desc,
          style: const TextStyle(color: kTextColor, fontSize: 15),
        ),
      ),
    );
  }
}
