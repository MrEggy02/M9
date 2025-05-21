// ໂມເດວຂໍ້ມູນບໍລິການຕ່າງໆ

class Service {
  final String id;
  final String name;
  final String iconUrl;
  final String description;
  final bool isActive;

  Service({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.description,
    this.isActive = true,
  });

  // ສ້າງ Service ຈາກ JSON ຂໍ້ມູນ
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      iconUrl: json['icon_url'],
      description: json['description'],
      isActive: json['is_active'] ?? true,
    );
  }

  // ແປງ Service ເປັນ JSON ຂໍ້ມູນ
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_url': iconUrl,
      'description': description,
      'is_active': isActive,
    };
  }
}