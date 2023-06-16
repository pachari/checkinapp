import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class FactoryAllModel {
  // final int id;
  final String title;
  final String subtitle;
  final int typeid;
  final GeoPoint position;
  final int id;
  // final double lat;
  // final double lng;
  final String qr;
  FactoryAllModel({
    required this.title,
    required this.subtitle,
    required this.typeid,
    required this.position,
    required this.id,
    required this.qr,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subtitle': subtitle,
      'typeid': typeid,
      'position': position,
      'id': id,
      'qr': qr,
    };
  }

  factory FactoryAllModel.fromMap(Map<String, dynamic> map) {
    return FactoryAllModel(
      title: (map['title'] ?? '') as String,
      subtitle: (map['subtitle'] ?? '') as String,
      typeid: (map['typeid'] ?? 0) as int,
      position: map['position'],
      id: (map['id'] ?? 0) as int,
      qr: (map['qr'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FactoryAllModel.fromJson(String source) =>
      FactoryAllModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
