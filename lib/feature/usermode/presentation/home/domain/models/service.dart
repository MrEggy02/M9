// ໂມເດວຂໍ້ມູນບໍລິການຕ່າງໆ

// ໂມເດວຂໍ້ມູນບໍລິການຕ່າງໆ



import 'dart:convert';

List<ServiceModel> serviceModelFromJson(String str) =>
    List<ServiceModel>.from(
      json.decode(str).map((x) => ServiceModel.fromJson(x)),
    );
class ServiceModel {
  final String? id;
  final String? name;
  final String? icon;
  final String? detail;
  final bool? isActive;
  final String? createAt;
  final String? updatedAt;

  ServiceModel({
    this.id,
    this.name,
    this.icon,
    this.detail,
    this.isActive,
    this.createAt,
    this.updatedAt,
  });

  // ສ້າງ Service ຈາກ JSON ຂໍ້ມູນ
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      detail: json['detail'],
      isActive: json['isActive'],
      createAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // ແປງ Service ເປັນ JSON ຂໍ້ມູນ
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'detail': detail,
      'isActive': isActive,
      'createdAt': createAt,
      'updatedAt': updatedAt,
    };
  }
}
