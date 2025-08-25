import 'dart:io';
import 'package:flutter/material.dart';

class AddBankForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController bankNameController;
  final TextEditingController accountNameController;
  final TextEditingController accountNoController;
  final File? selectedImage;
  final VoidCallback onImagePick;
  final VoidCallback onSubmit;

  const AddBankForm({
    super.key,
    required this.formKey,
    required this.bankNameController,
    required this.accountNameController,
    required this.accountNoController,
    required this.selectedImage,
    required this.onImagePick,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
            const FormTitle(),
            const SizedBox(height: 20),
            ImagePicker(
              selectedImage: selectedImage,
              onImagePick: onImagePick,
            ),
            const SizedBox(height: 20),
            BankInputField(
              label: 'ຊື່ທະນາຄານ',
              icon: Icons.account_balance,
              controller: bankNameController,
              validator: (value) => value == null || value.isEmpty ? 'ກະລຸນາປ້ອນຊື່ທະນາຄານ' : null,
            ),
            BankInputField(
              label: 'ຊື່ເຈົ້າຂອງບັນຊີ',
              icon: Icons.person,
              controller: accountNameController,
              validator: (value) => value == null || value.isEmpty ? 'ກະລຸນາປ້ອນຊື່ເຈົ້າຂອງບັນຊີ' : null,
            ),
            BankInputField(
              label: 'ເລກບັນຊີ',
              icon: Icons.numbers,
              controller: accountNoController,
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.isEmpty ? 'ກະລຸນາປ້ອນເລກບັນຊີ' : null,
            ),
            const SizedBox(height: 30),
            SubmitButton(onSubmit: onSubmit),
          ],
        ),
      ),
    );
  }
}

class FormTitle extends StatelessWidget {
  const FormTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'ຂໍ້ມູນບັນຊີໃໝ່',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}

class ImagePicker extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onImagePick;

  const ImagePicker({
    super.key,
    required this.selectedImage,
    required this.onImagePick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onImagePick,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('ເລືອກຮູບພາບ', style: TextStyle(color: Colors.grey)),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(selectedImage!, fit: BoxFit.cover),
              ),
      ),
    );
  }
}

class BankInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const BankInputField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
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
}

class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitButton({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onSubmit,
      icon: const Icon(Icons.add_circle_outline),
      label: const Text(
        'ເພີ່ມບັນຊີ',
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
    );
  }
}