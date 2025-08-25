import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m9/feature/auth/domain/models/bank_account_model.dart';

class BankAccountDetails extends StatelessWidget {
  final BankAccount account;
  final VoidCallback onEdit;

  const BankAccountDetails({
    super.key,
    required this.account,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          DetailItem(
            icon: Icons.person_outline,
            title: 'ຊື່ເຈົ້າຂອງບັນຊີ',
            value: account.accountName,
          ),
          const Divider(height: 24),
          if (account.createdAt != null)
            DetailItem(
              icon: Icons.calendar_today_outlined,
              title: 'ວັນທີ່ສ້າງ',
              value: '${account.createdAt!.day}/${account.createdAt!.month}/${account.createdAt!.year}',
            ),
          const SizedBox(height: 24),
          // Only show edit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFECE0C),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('ແກ້ໄຂ'),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFFECE0C), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}