import 'package:cloud_firestore/cloud_firestore.dart';

class NetWorkModel {
  String photo;
  String name;
  String phone;
  bool isSelect;
  Timestamp? dobFormat;

  NetWorkModel({
    required this.name,
    required this.phone,
    required this.photo,
    required this.isSelect,
    this.dobFormat,
  });
}
