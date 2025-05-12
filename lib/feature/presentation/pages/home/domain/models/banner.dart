// ໂມເດວຂໍ້ມູນແບນເນີ້ໂຄສະນາ

class BannerModel {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String companyName;
  final String companyLogoUrl;
  final bool isActive;

  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.companyName,
    required this.companyLogoUrl,
    this.isActive = true,
  });

  // ສ້າງ Banner ຈາກ JSON ຂໍ້ມູນ
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      imageUrl: json['image_url'],
      title: json['title'],
      subtitle: json['subtitle'],
      companyName: json['company_name'],
      companyLogoUrl: json['company_logo_url'],
      isActive: json['is_active'] ?? true,
    );
  }

  // ແປງ Banner ເປັນ JSON ຂໍ້ມູນ
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'title': title,
      'subtitle': subtitle,
      'company_name': companyName,
      'company_logo_url': companyLogoUrl,
      'is_active': isActive,
    };
  }
}