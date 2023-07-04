// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';
import 'package:checkinapp/utility/app_controller.dart';
// import 'package:checkinapp/utility/app_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:checkinapp/models/todo_model.dart';
part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListState.initial()) {
    on<AddTodoEvent>(_addTodo);
    on<EditTodoEvent>(_editTodo);
    on<ToggleTodoEvent>(_toggleTodo);
    on<RemoveTodoEvent>(_removeTodo);
    on<SaveTodoEvent>(_saveTodo);
    on<ClearTodoEvent>(_clearTodo);
  }
  void _addTodo(AddTodoEvent event, Emitter<TodoListState> emit) {
    int countst = state.todos.length + 1;

    final newTodo = Todo(id: '$countst', desc: event.todoDesc);
    final newTodos = [...state.todos, newTodo];
    // emit(state.copyWith(todos: newTodos));
    emit(state.copyWith(todos: newTodos));
  }

  void _editTodo(EditTodoEvent event, Emitter<TodoListState> emit) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == event.id) {
        return Todo(
          id: event.id,
          desc: event.todoDesc,
          completed: todo.completed,
        );
      }
      return todo;
    }).toList();
    emit(state.copyWith(todos: newTodos));
  }

  void _toggleTodo(ToggleTodoEvent event, Emitter<TodoListState> emit) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == event.id) {
        return Todo(
          id: event.id,
          desc: todo.desc,
          completed: !todo.completed,
        );
      }

      return todo;
    }).toList();
    emit(state.copyWith(todos: newTodos));
    print(state);
  }

  //ไม่ได้ใช้ตัวนี้
  void _clearTodo(ClearTodoEvent event, Emitter<TodoListState> emit) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == event.id) {
        return Todo(
          id: event.id,
          desc: todo.desc,
          completed: false,
        );
      }

      return todo;
    }).toList();
    emit(state.copyWith(todos: newTodos));
    print(state);
  }

  void _removeTodo(RemoveTodoEvent event, Emitter<TodoListState> emit) {
    final newTodos =
        state.todos.where((Todo t) => t.id != event.todo.id).toList();
    emit(state.copyWith(todos: newTodos));
  }

  Future<void> _saveTodo(
      SaveTodoEvent event, Emitter<TodoListState> emit) async {
    List finishtodo = [];
    final user = FirebaseAuth.instance.currentUser;
    // CollectionReference checkintodolists = FirebaseFirestore.instance.collection('checkin');
    CollectionReference todolists =
        FirebaseFirestore.instance.collection('todolist');
    var formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
    for (int i = 0; i < state.todos.length; i++) {
      finishtodo.add(state.todos[i].completed);
      //clear data completed type true
      // if (state.todos[i].completed == true) {
      //   final newTodos = state.todos.map((Todo todo) {
      //     if (todo.id == '$i') {
      //       return Todo(
      //         id: '$i',
      //         desc: todo.desc,
      //         completed: !todo.completed,
      //       );
      //     }

      //     return todo;
      //   }).toList();
      //   emit(state.copyWith(todos: newTodos));
      // }
    }
    try {
      //before
      // await todolists.doc("id${event.id}").collection("todo").add({
      //   "finishtodo": finishtodo,
      //   "timestampIn": DateTime.now(),
      //   "timestampOut": DateTime.now(),
      //   "uidCheck": user?.uid,
      // });
      //After 1 เป็นการ insert collection ต่อท้ายของตัว Checkin
      // await checkintodolists
      //     .doc("id${event.id}")
      //     .collection("todo")
      //     .doc(formattedDate)
      //     .set({
      //   "finishtodo": finishtodo,
      //   "timestampIn": DateTime.now(),
      //   "timestampOut": DateTime.now(),
      //   "uidCheck": user?.uid,
      //   "checkinid":event.id
      // });
      //After 2 เป็นการ insert collection แยก ไม่ต่อท้ายตัวไหน ขึ้นใหม่เลย
      await todolists
          .doc(user?.uid)
          .collection(formattedDate)
          .doc(event.id)
          .update({
        "finishtodo": finishtodo,
        // "timestampIn": DateTime.now(),
        "timestampOut": DateTime.now(),
        "todostatus": 2,
        // "checkinid": event.id,
      });
    } catch (e) {
      print(e);
    }
    print(state);
  }
}
