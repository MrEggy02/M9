import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // ✅ ใช้ format วันที่
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';

class DatePersonalWidget extends StatefulWidget {
  final TextEditingController controller;

  const DatePersonalWidget({super.key, required this.controller});

  @override
  State<DatePersonalWidget> createState() => _DatePersonalWidgetState();
}

class _DatePersonalWidgetState extends State<DatePersonalWidget> {
  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd");

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return "";
    try {
      final dt = DateTime.parse(raw);
      return _dateFormat.format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.failure) {
          print("====>${state.error}");
        }
      },
      builder: (context, state) {
        var cubit = context.read<AuthCubit>();
        cubit.dobController.text = _formatDate(cubit.dobController.text);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: Colors.indigo.shade800,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate:
                          cubit.dobController.text.isNotEmpty
                              ? DateTime.tryParse(cubit.dobController.text) ??
                                  DateTime.now()
                              : DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        cubit.dobController.text = _dateFormat.format(picked);
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: cubit.dobController,
                      decoration: const InputDecoration(
                        hintText: 'ວັນເກີດ',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
            ],
          ),
        );
      },
    );
  }
}
