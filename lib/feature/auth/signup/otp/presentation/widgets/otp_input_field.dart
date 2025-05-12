// lib/presentation/widgets/otp_input_field.dart
import 'package:flutter/material.dart';
import 'package:m9/feature/auth/signup/otp/presentation/controllers/otp_controller.dart';

// ວິດເຈັດສຳລັບຊ່ອງປ້ອນລະຫັດ OTP
class OtpInputField extends StatelessWidget {
  final OtpController controller;
  
  const OtpInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            6,
            (index) => Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.amber,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  index < controller.otp.length ? '-' : '-',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}