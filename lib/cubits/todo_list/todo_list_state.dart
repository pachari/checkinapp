part of 'filtered_todos_list.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;

  const TodoListState({required this.todos});

  factory TodoListState.initial() {
    // AppService().readUserModel();
    AppController controller = Get.put(AppController());
    List<Todo> strarray = [];
    for (var i = 0; i < controller.userModels.last.todo.length; i++) {
      strarray.add(Todo(id: '$i', desc: controller.userModels[0].todo[i]));
    }
    return TodoListState(todos: strarray);
  }

  // factory TodoListState.initial() {
  //   return TodoListState(todos: [
  //     Todo(id: '1', desc: 'กวาดพื้น'),
  // Todo(id: '2', desc: 'ดูดฝุ่น'),
  // Todo(id: '3', desc: 'ถูพื้น'),
  // Todo(id: '4', desc: 'เก็บขยะ'),
  // Todo(id: '5', desc: 'เช็ดตู้เอกสาร'),
  // Todo(id: '6', desc: 'เช็ดโต๊ะ'),
  // Todo(id: '7', desc: 'ทำความสะอาด เครื่องใช้สำนักงาน'),
  // Todo(id: '8', desc: 'ทำความสะอาด ถังขยะ'),
  // Todo(id: '9', desc: 'ทำความสะอาด ห้องน้ำ'),
  // Todo(id: '10', desc: 'ทำความสะอาด เพดาน'),
  // Todo(id: '11', desc: 'ทำความสะอาด ผนัง'),
  // Todo(id: '12', desc: 'ทำความสะอาด ตู้เย็น'),
  // Todo(id: '13', desc: 'ทำความสะอาด พัดลม'),
  // Todo(id: '14', desc: 'อื่นๆ'),
  //   ]);
  // }

  @override
  List<Object> get props => [todos];

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }

  @override
  String toString() {
    return 'TodoListState{todos: $todos}';
  }
}
