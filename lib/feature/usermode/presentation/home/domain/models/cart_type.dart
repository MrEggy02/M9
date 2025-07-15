// ໂມເດວຂໍ້ມູນແບນເນີ້ໂຄສະນາ
import 'dart:convert';

List<CartTypeModel> cartTypeModelFromJson(String str) =>
    List<CartTypeModel>.from(
      json.decode(str).map((x) => CartTypeModel.fromJson(x)),
    );

class CartTypeModel {
  final String? id;
  final String? code;
  final String? icon;
  final String? name;
  final String? detail;
  final int? capacity;
  final int? basePrice;
  final int? priceKm;
  final String? createdAt;
  final String? updatedAt;

  CartTypeModel({
    this.id,
    this.code,
    this.icon,
    this.name,
    this.detail,
    this.capacity,
    this.basePrice,
    this.priceKm,
    this.createdAt,
    this.updatedAt,
  });

  // ສ້າງ Banner ຈາກ JSON ຂໍ້ມູນ
  factory CartTypeModel.fromJson(Map<String, dynamic> json) {
    return CartTypeModel(
      id: json['id'],
      code: json['code'],
      icon: json['icon'],
      name: json['name'],
      detail: json['detail'],
      capacity: json['capacity'],
      basePrice: json['basePrice'],
      priceKm: json['priceKm'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // ແປງ Banner ເປັນ JSON ຂໍ້ມູນ
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'icon': icon,
      'name': name,
      'detail': detail,
      'capacity': capacity,
      'basePrice': basePrice,
      'priceKm': priceKm,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
