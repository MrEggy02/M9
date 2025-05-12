// presentation/widgets/dot_indicator.dart
import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart';

class DotIndicator extends StatelessWidget {
  // ຕົວຊີ້ບອກຈຸດສຳລັບໜ້າ onboarding
  // ตัวชี้บอกจุดสำหรับหน้า onboarding
  final bool isActive;

  const DotIndicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 24 : 8,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}