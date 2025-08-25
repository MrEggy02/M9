import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart';

class TxtPersonalWidget extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String name;
  final TextInputType type;

  const TxtPersonalWidget({
    super.key,
    required this.controller,
    required this.icon,
    required this.name,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller, // ✅ ใช้ controller ตรง ๆ
        keyboardType: type,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.indigo.shade800),
          hintText: name,
        ),
      ),
    );
  }
}

