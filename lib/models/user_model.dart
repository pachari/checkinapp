import 'dart:convert';

class UserModel {
  final String name;
  final List<String> todo;
  UserModel({
    required this.name,
    required this.todo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'todo': todo,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: (map['name'] ?? '') as String,
      todo: List<String>.from(map['todo'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
