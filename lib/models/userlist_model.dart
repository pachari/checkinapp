// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserListModel {
  final String email;
  final String name;
  final String role;
  final List<String> todo;
  final String uid;
  final int typeworkid;
  UserListModel({
    required this.email,
    required this.name,
    required this.role,
    required this.todo,
    required this.uid,
    required this.typeworkid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'role': role,
      'todo': todo,
      'uid': uid,
      'typeworkid': typeworkid,
    };
  }

  factory UserListModel.fromMap(Map<String, dynamic> map) {
    return UserListModel(
      email: (map['email'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      role: (map['role'] ?? '') as String,
      todo: List<String>.from((map['todo'] ?? const <String>[]) as List<String>),
      uid: (map['uid'] ?? '') as String,
      typeworkid: (map['typeworkid'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserListModel.fromJson(String source) =>
      UserListModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
