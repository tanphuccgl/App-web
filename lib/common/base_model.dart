import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseModel {
  String id;
  Timestamp? createAt;
  Timestamp? updateAt;
  BaseModel({this.id = '', this.createAt, this.updateAt}) {
    Timestamp createAt = Timestamp.now();
    this.createAt = this.createAt ?? createAt;
  }
}
