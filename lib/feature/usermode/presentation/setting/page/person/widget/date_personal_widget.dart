import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';

class DatePersonalWidget extends StatefulWidget {
  const DatePersonalWidget({super.key});

  @override
  State<DatePersonalWidget> createState() => _DatePersonalWidgetState();
}

class _DatePersonalWidgetState extends State<DatePersonalWidget> {
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
                  onTap: () {
                   // selectDate();
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
