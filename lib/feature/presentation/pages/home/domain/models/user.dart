// ໂມເດວຂໍ້ມູນຜູ້ໃຊ້ແອັບ

class User {
  final String id;
  final String name;
  final String phoneNumber;
  final int stars;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.stars,
    this.profileImageUrl,
  });

  // ສ້າງ User ຈາກ JSON ຂໍ້ມູນ
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      stars: json['stars'],
      profileImageUrl: json['profile_image_url'],
    );
  }

  // ແປງ User ເປັນ JSON ຂໍ້ມູນ
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'stars': stars,
      'profile_image_url': profileImageUrl,
    };
  }
}