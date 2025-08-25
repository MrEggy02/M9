
import 'package:m9/core/constants/app_constants.dart';

// Update your BankAccount model
class BankAccount {
  final String id;
  final String bankName;
  final String accountName;
  final String accountNo;
  final bool isActive;
  final String? image;
  final String? userId;
  final DateTime? createdAt;

  bool get isDefault => isActive;


  String? get safeImageUrl {
    if (image == null || image!.isEmpty) return null;
    
    try {
      if (image!.startsWith('http://') || image!.startsWith('https://')) {
        return image;
      }
      
      // If image is just a path/filename, combine with base URL
      return AppConstants.imageUrl + image!;
    } catch (e) {
      return null;
    }
  }

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
      image: json['image']?.toString(), // Keep original image path
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
    'image': image,
    'userId': userId,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
  };

  BankAccount copyWith({
    String? id,
    String? bankName,
    String? accountName,
    String? accountNo,
    bool? isActive,
    String? image,
    String? userId,
    DateTime? createdAt,
  }) {
    return BankAccount(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountName: accountName ?? this.accountName,
      accountNo: accountNo ?? this.accountNo,
      isActive: isActive ?? this.isActive,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

extension on String? {
  DateTime? toDateTime() => this != null ? DateTime.tryParse(this!) : null;
}
