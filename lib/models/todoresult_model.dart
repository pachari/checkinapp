// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoResultModels {
  final String uidCheck;
  final Timestamp timestampIn;
  final Timestamp? timestampOut;
  final List<bool> finishtodo;
  final int checkinid;
  final String image;
  final int? todostatus;
  final String todoresultid;
  
  TodoResultModels({
    required this.uidCheck,
    required this.timestampIn,
    this.timestampOut,
    required this.finishtodo,
    required this.checkinid,
    required this.image,
    required this.todostatus,
    required this.todoresultid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uidCheck': uidCheck,
      'timestampIn': timestampIn,
      'timestampOut': timestampOut,
      'finishtodo': finishtodo,
      'checkinid': checkinid,
      'image': image,
      'todostatus': todostatus,
      'todoresultid': todoresultid,
    };
  }

  factory TodoResultModels.fromMap(Map<String, dynamic> map) {
    return TodoResultModels(
      uidCheck: (map['uidCheck'] ?? '') as String,
      timestampIn: map['timestampIn'],
      timestampOut: map['timestampOut'] ,
      finishtodo: List<bool>.from((map['finishtodo'] ?? const <bool>[]) as List<bool>),
      checkinid: (map['checkinid'] ?? 0) as int,
      image: (map['image'] ?? '') as String,
      todostatus: map['todostatus'] != null ? map['todostatus'] as int : null,
      todoresultid: (map['todoresultid'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoResultModels.fromJson(String source) =>
      TodoResultModels.fromMap(json.decode(source) as Map<String, dynamic>);
}
