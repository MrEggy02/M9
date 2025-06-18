// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  // ຕົວປ່ຽນພາຍນອກທີ່ສົ່ງມາ
  String? id;
  String? username;
  String? firstName;
  String? lastName;
  String? displayName;
  String? phoneNumber;
  String? password;
  String? email;
  String? role;
  String? dob;
  String? address;
  String? avatar;
  String? token;
  String? refreshToken;

  // ເປັນ ຕົວປ່ຽນພາຍໃນໃຊ້ໃນ model
  UserModel({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.displayName,
    this.phoneNumber,
    this.password,
    this.email,
    this.role,
    this.dob,
    this.address,
    this.avatar,
    this.token,
    this.refreshToken,
  });
  // ເປັນການສ້າງ from ຂໍ້ມູນເພື່ອເອົາໄປໃສ່ງານ
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    username: json["username"],
    phoneNumber: json["phoneNumber"],
    password: json["password"],
    displayName: json['displayName'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    role: json['role'],
    dob: json['dob'],
    avatar: json['avatar'],
    token: json["token"],
    refreshToken: json["refreshToken"],
  );
  // ເປັນການສົ່ງຂໍ້ມູນກັບຄືນຫາ server
  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "phoneNumber": phoneNumber,
    "password": password,
    "displayName": displayName,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "role": role,
    "dob": dob,
    "avatar": avatar,
    "token": token,
    "refreshToken": refreshToken,
  };
}
