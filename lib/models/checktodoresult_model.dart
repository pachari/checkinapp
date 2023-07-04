// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CheckTodoResultModels {
  final int result;
  final List<String> resultcheckinid;
  final String collectiondate;
  
  CheckTodoResultModels({
    required this.result,
    required this.resultcheckinid,
    required this.collectiondate,
    
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'result': result,
      'resultcheckinid': resultcheckinid,
      'collectiondate': collectiondate,
    };
  }

  factory CheckTodoResultModels.fromMap(Map<String, dynamic> map) {
    return CheckTodoResultModels(
      result: (map['result'] ?? 0) as int,
      resultcheckinid: List<String>.from((map['resultcheckinid'] ?? const <String>[]) as List<String>),
      collectiondate: (map['collectiondate'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckTodoResultModels.fromJson(String source) =>
      CheckTodoResultModels.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
