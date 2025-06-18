// ໂມເດວຂໍ້ມູນແບນເນີ້ໂຄສະນາ
import 'dart:convert';

List<BannerModel> bannerModelFromJson(String str) => List<BannerModel>.from(
  json.decode(str).map((x) => BannerModel.fromJson(x)),
);

class BannerModel {
  final String? id;
  final String? image;
  final String? title;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  BannerModel({
    this.id,
    this.image,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  // ສ້າງ Banner ຈາກ JSON ຂໍ້ມູນ
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // ແປງ Banner ເປັນ JSON ຂໍ້ມູນ
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
