// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  String userName;
  String email;
  String phoneNumber;
  String userFcmToken;
  String userId;
  String userRole;

  UserModel({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.userId,
    required this.userFcmToken,
    required this.userRole,
  });

  UserModel copyWith({
    String? userName,
    String? email,
    String? phoneNumber,
    String? userFcmToken,
    String? userId,
    String? userRole,
  }) =>
      UserModel(
          userName: userName ?? this.userName,
          email: email ?? this.email,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          userFcmToken: userFcmToken ?? this.userFcmToken,
          userId: userId ?? this.userId,
          userRole: userRole ?? this.userRole);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      userName: json["userName"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      userFcmToken: json["userFcmToken"],
      userRole: json["userRole"],
      userId: json["userId"]);

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "email": email,
        "phoneNumber": phoneNumber,
        "userFcmToken": userFcmToken,
        "userId": userId,
        "userRole": userRole
      };

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "userName": userName,
      "email": email,
      "phoneNumber": phoneNumber,
      "userFcmToken": userFcmToken,
      "userId": userId,
      "userRole": userRole
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        userName: (map['userName'] ?? ''),
        userId: (map['userId'] ?? ''),
        email: (map['email'] ?? ''),
        phoneNumber: map['phoneNumber'],
        userRole: map["userRole"],
        userFcmToken: map["userFcmToken"]);
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
        userName: (data['userName'] ?? ''),
        userId: (data['userId'] ?? ''),
        email: (data['email'] ?? ''),
        phoneNumber: data['phoneNumber'],
        userRole: data["userRole"],
        userFcmToken: data["userFcmToken"]);
  }
}
