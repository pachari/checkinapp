import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CalendarAllEvent {
  final String uidCheck;
  final List<String> dataDate;
  final List<String> finishtodosid;
  CalendarAllEvent({
    required this.uidCheck,
    required this.dataDate,
    required this.finishtodosid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uidCheck': uidCheck,
      'dataDate': dataDate,
      'finishtodosid': finishtodosid,
    };
  }

  factory CalendarAllEvent.fromMap(Map<String, dynamic> map) {
    return CalendarAllEvent(
      uidCheck: (map['uidCheck'] ?? '') as String,
      dataDate: List<String>.from((map['dataDate'] ?? const <String>[]) as List<String>),
      finishtodosid: List<String>.from((map['finishtodosid'] ?? const <String>[]) as List<String>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CalendarAllEvent.fromJson(String source) =>
      CalendarAllEvent.fromMap(json.decode(source) as Map<String, dynamic>);
}
