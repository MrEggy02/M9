import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/data/network/api_path.dart';
import 'package:m9/feature/auth/domain/models/bank_account_model.dart';

class EditBankAccountWidget extends StatelessWidget {
  final BankAccount account;
  final XFile? selectedImage;
  final bool isUploadingImage;
  final VoidCallback onPickImage;
  final Function(
    TextEditingController,
    TextEditingController,
    TextEditingController,
  ) onSubmit;

  const EditBankAccountWidget({
    super.key,
    required this.account,
    required this.selectedImage,
    required this.isUploadingImage,
    required this.onPickImage,
    required this.onSubmit,
  });

  static Future<String?> uploadImageToServer(
    BuildContext context,
    File imageFile,
    BankAccount account,
  ) async {
    try {
      final token = await HiveDatabase.getToken();
      
      // Try multipart upload first
      var request = http.MultipartRequest('PUT', Uri.parse(ApiPaths.editBankAccountPath));
      
      // Add headers
      if (token != null && token['token'] != null) {
        request.headers['Authorization'] = 'Bearer ${token['token']}';
      }
      request.headers['Accept'] = 'application/json';
      
      // Add form fields
      request.fields['id'] = account.id;
      request.fields['bankName'] = account.bankName;
      request.fields['accountName'] = account.accountName;
      request.fields['accountNo'] = account.accountNo;
      request.fields['isActive'] = account.isActive.toString();
      
      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType.parse(lookupMimeType(imageFile.path) ?? 'image/jpeg'),
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      
      print('📤 Upload response: ${response.statusCode} - $responseData');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(responseData);
        if (data['status'] == true || data['data'] != null) {
          final imageData = data['data'] ?? data;
          return imageData['image'];
        }
      }
      
      // If multipart fails, fall back to base64 method
      print('🔄 Multipart failed, trying base64...');
      return await _uploadImageAsBase64(imageFile, account, token);
      
    } catch (e) {
      print('❌ Multipart upload error: $e');
      // Fall back to base64 method
      final token = await HiveDatabase.getToken();
      return await _uploadImageAsBase64(imageFile, account, token);
    }
  }

  static Future<String?> _uploadImageAsBase64(
    File imageFile,
    BankAccount account,
    Map<String, dynamic>? token,
  ) async {
    try {
      // Convert image to base64 string
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      final requestData = {
        "id": account.id,
        "bankName": account.bankName,
        "accountName": account.accountName,
        "accountNo": account.accountNo,
        "isActive": account.isActive,
        "image": base64Image,
      };

      final response = await http.put(
        Uri.parse(ApiPaths.editBankAccountPath),
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer ${token?['token']}",
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      final data = jsonDecode(response.body);
      print('📤 Base64 upload response: ${response.statusCode} - $data');

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          (data['status'] == true || data['data'] != null)) {
        final imageData = data['data'] ?? data;
        return imageData['image'];
      } else {
        throw Exception(data['message'] ?? 'Upload failed');
      }
    } catch (e) {
      print('❌ Base64 upload error: $e');
      throw Exception('Upload error: $e');
    }
  }

  Widget _buildInput({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return const Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: 50,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildDefaultBankIcon() {
    return const Center(
      child: Icon(
        Icons.account_balance,
        size: 50,
        color: Colors.black54,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController bankNameController = TextEditingController(text: account.bankName);
    final TextEditingController accountNameController = TextEditingController(text: account.accountName);
    final TextEditingController accountNoController = TextEditingController(text: account.accountNo);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ຂໍ້ມູນບັນຊີທະນາຄານ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            
            // Image container with update functionality
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 240,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isUploadingImage
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFECE0C),
                            ),
                          )
                        : selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(selectedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : account.safeImageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      imageUrl: account.safeImageUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFFFECE0C),
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          _buildImageError(),
                                    ),
                                  )
                                : _buildDefaultBankIcon(),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onPickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFECE0C),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                selectedImage != null ? 'ຮູບພາບໃໝ່' : 'ຮູບພາບປັດຈຸບັນ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            _buildInput(
              label: 'ຊື່ທະນາຄານ',
              icon: Icons.account_balance,
              controller: bankNameController,
            ),
            _buildInput(
              label: 'ຊື່ເຈົ້າຂອງບັນຊີ',
              icon: Icons.person,
              controller: accountNameController,
            ),
            _buildInput(
              label: 'ເລກບັນຊີ',
              icon: Icons.numbers,
              controller: accountNoController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => onSubmit(
                bankNameController,
                accountNameController,
                accountNoController,
              ),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(
                'ບັນທຶກ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFECE0C),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}