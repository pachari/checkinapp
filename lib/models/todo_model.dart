import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

// import '../blocs/todo_list/todo_list_bloc.dart';


Uuid uuid = const Uuid();
enum Filter {
  all,
  active,
  completed,
}

class Todo extends Equatable{
  final String id;
  final String desc;
  final bool completed;
  // final notification = TodoListState.initial();
  

  Todo({
    String? id,
    required this.desc,
    this.completed = false,
  }) : id = id ?? uuid.v4() ; //uuid.v4()

  @override
  List<Object?> get props => [id, desc, completed];

  @override
  String toString() {
    return 'Todo{id: $id, desc: $desc, completed: $completed}';
  }
}
