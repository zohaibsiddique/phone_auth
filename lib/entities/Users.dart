import 'package:cloud_firestore/cloud_firestore.dart';

class Users{

  String name, dob, image;
  FieldValue interests;
  bool gender;

  Users({this.name, this.dob, this.gender, this.image, this.interests});

  Map<String, dynamic> toJson() => {
    'name': name,
    'dob': dob,
    'gender': gender,
    'image': image,
    'interests': interests,
  };
}