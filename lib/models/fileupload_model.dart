import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FileUploads {
  final String image;
  final String name;
  final String remark;
  final String uid;
  final String factoryid;
  FileUploads({
    required this.image,
    required this.name,
    required this.remark,
    required this.uid,
    required this.factoryid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'name': name,
      'remark': remark,
      'uid': uid,
      'factoryid': factoryid,
    };
  }

  factory FileUploads.fromMap(Map<String, dynamic> map) {
    return FileUploads(
      image: (map['image'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      remark: (map['remark'] ?? '') as String,
      uid: (map['uid'] ?? '') as String,
      factoryid: (map['factoryid'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FileUploads.fromJson(String source) =>
      FileUploads.fromMap(json.decode(source) as Map<String, dynamic>);
}
