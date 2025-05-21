import 'package:flutter/material.dart';

class ServiceCategory extends StatelessWidget {
  final IconData icon;
  final String title;

  const ServiceCategory({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ໄອຄອນບໍລິການ - ຈະແທນທີ່ດ້ວຍຮູບຈາກ Figma
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: icon == Icons.local_taxi 
                  ? const Color(0xFFFFCC00)
                  : icon == Icons.location_on
                      ? Colors.red
                      : Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          // ຊື່ບໍລິການ
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}