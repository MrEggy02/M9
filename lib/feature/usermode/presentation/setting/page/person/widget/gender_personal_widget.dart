import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';

class GenderPersonalWidget extends StatefulWidget {
  const GenderPersonalWidget({super.key});

  @override
  State<GenderPersonalWidget> createState() => _GenderPersonalWidgetState();
}

class _GenderPersonalWidgetState extends State<GenderPersonalWidget> {
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
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.wc, color: Colors.indigo.shade800),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButton<String>(
                  value:
                      cubit.selectedGender != null 
                          ? cubit.selectedGender
                          : null,
                  hint: const Text("ເລືອກເພດ"),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items:
                      ['ຊາຍ', 'ຍິງ']
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      cubit.selectedGender = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
