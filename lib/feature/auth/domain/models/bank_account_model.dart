import 'dart:convert';

List<BankAccount> bankModelFromJson(String str) => List<BankAccount>.from(
    json.decode(str).map((x) => BankAccount.fromJson(x)));
class BankAccount {
  final String id, bankName, accountName, accountNo;
  final bool isActive;
  final String? image, userId;
  final DateTime? createdAt;

  bool get isDefault => isActive;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountName,
    required this.accountNo,
    required this.isActive,
    this.image,
    this.userId,
    this.createdAt,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      accountName: json['accountName']?.toString() ?? '',
      accountNo: json['accountNo']?.toString() ?? '',
      isActive: json['isActive'] ?? false,
      image: json['image']?.toString(),
      userId: json['userId']?.toString(),
      createdAt: json['createdAt']?.toString().toDateTime(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'bankName': bankName,
    'accountName': accountName,
    'accountNo': accountNo,
    'isActive': isActive,
    if (image != null) 'image': image,
    if (userId != null) 'userId': userId,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
  };
}

extension on String? {
  DateTime? toDateTime() => this != null ? DateTime.tryParse(this!) : null;
}
