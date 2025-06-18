// lib/presentation/widgets/password_input_field.dart
// ຄອມໂພເນັນສຳລັບຊ່ອງປ້ອນລະຫັດຜ່ານ

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';

class PasswordInputField extends StatefulWidget {
  const PasswordInputField({super.key});

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.failure) {
          print('login error=>${state.error}');
        }
      },
      builder: (context, state) {
        var cubit = context.read<AuthCubit>();

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: const Icon(Icons.lock, color: Colors.black),
              ),
              Expanded(
                child: TextFormField(
                  //initialValue: cubit.dataRemember['password'],
                  onChanged: (value) {
                    setState(() {
                      cubit.password.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'ປ້ອນລະຫັດຜ່ານ...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
