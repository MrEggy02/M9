import 'dart:convert';

List<UserSurveyDriverModel> userSurveyModelFromJson(String str) =>
    List<UserSurveyDriverModel>.from(
      json.decode(str).map((x) => UserSurveyDriverModel.fromJson(x)),
    );
    
class UserSurveyDriverModel {
  final String? id;
  final String? uuid;
  final String? carTypeId;
  final String? carTypeCode;
  final String? carTypeName;
  final double? lat;
  final double? lon;

  UserSurveyDriverModel({
    this.id,
    this.uuid,
    this.carTypeId,
    this.carTypeCode,
    this.carTypeName,
    this.lat,
    this.lon,
  });

  // ສ້າງ Banner ຈາກ JSON ຂໍ້ມູນ
  factory UserSurveyDriverModel.fromJson(Map<String, dynamic> json) {
    return UserSurveyDriverModel(
      id: json['id'],
      uuid: json['uuid'],
      carTypeId: json['carTypeId'],
      carTypeCode: json['carTypeCode'],
      carTypeName: json['carTypeName'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  // ແປງ Banner ເປັນ JSON ຂໍ້ມູນ
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'carTypeId': carTypeId,
      'carTypeCode': carTypeCode,
      'carTypeName': carTypeName,
      'lat': lat,
      'lon': lon,
    };
  }
}
