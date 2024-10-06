import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;

  UserModel({required this.id, required this.name});

  ///In this case id comes from outside, but id must come from json.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: "1",
      name: json['name'] as String? ?? "",
    );
  }

  static List<UserModel> fromList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }
}
