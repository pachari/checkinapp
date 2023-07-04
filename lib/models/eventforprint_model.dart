import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AlleventforPrint {
  final String uidCheck;
  final List<String> dataDate;
  final List<String> finishtodosid;
  final String name;
  final String beginDate;
  final String endDate;
  AlleventforPrint({
    required this.uidCheck,
    required this.dataDate,
    required this.finishtodosid,
    required this.name,
    required this.beginDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uidCheck': uidCheck,
      'dataDate': dataDate,
      'finishtodosid': finishtodosid,
      'name': name,
      'beginDate': beginDate,
      'endDate': endDate,
    };
  }

  factory AlleventforPrint.fromMap(Map<String, dynamic> map) {
    return AlleventforPrint(
      uidCheck: (map['uidCheck'] ?? '') as String,
      dataDate: List<String>.from((map['dataDate'] ?? const <String>[]) as List<String>),
      finishtodosid: List<String>.from((map['finishtodosid'] ?? const <String>[]) as List<String>),
      name: (map['name'] ?? '') as String,
      beginDate: (map['beginDate'] ?? '') as String,
      endDate: (map['endDate'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlleventforPrint.fromJson(String source) =>
      AlleventforPrint.fromMap(json.decode(source) as Map<String, dynamic>);
}
