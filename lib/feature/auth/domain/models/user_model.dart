// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? username;
  String? firstName;
  String? lastName;
  String? displayName;
  String? phoneNumber;
  String? email;
  String? role;
  String? dob;
  String? address;
  String? avatar;
  String? token;
  String? refreshToken;
  String? gender;

  UserModel({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.displayName,
    this.phoneNumber,
    this.email,
    this.role,
    this.dob,
    this.address,
    this.avatar,
    this.token,
    this.refreshToken,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"]?.toString(),
        username: json["username"]?.toString() ?? '',
        firstName: json["firstName"]?.toString() ?? '',
        lastName: json["lastName"]?.toString() ?? '',
        displayName: json["displayName"]?.toString(),
        phoneNumber: json["phoneNumber"]?.toString(),
        email: json["email"]?.toString() ?? '',
        role: json["role"]?.toString(),
        dob: json["dob"]?.toString(),
        address: json["address"]?.toString() ?? '',
        avatar: json["avatar"]?.toString(),
        token: json["token"]?.toString(),
        refreshToken: json["refreshToken"]?.toString(),
        gender: json["gender"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "displayName": displayName,
        "phoneNumber": phoneNumber,
        "email": email,
        "role": role,
        "dob": dob,
        "address": address,
        "avatar": avatar,
        "token": token,
        "refreshToken": refreshToken,
        "gender": gender,
      };
}
