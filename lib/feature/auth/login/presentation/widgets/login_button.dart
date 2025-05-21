
// lib/presentation/widgets/login_button.dart
// ຄອມໂພເນັນສຳລັບປຸ່ມເຂົ້າສູ່ລະບົບ

import 'package:flutter/material.dart';
import 'package:m9/core/routes/app_routes.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, AppRoutes.homepage);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'ເຂົ້າສູ່ລະບົບ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
