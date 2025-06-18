// lib/presentation/widgets/register_button.dart
// ຄອມໂພເນັນສຳລັບປຸ່ມລົງທະບຽນ

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

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
        var size = MediaQuery.of(context).size;
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (cubit.phoneNumber.text.isEmpty) {
                MessageHelper.showTopSnackBar(
                  context: context,
                  message: "ເບີໂທຫ້າມວ່າງ!",
                  isSuccess: false,
                );
              }else{
                Navigator.pushNamed(context, AppRoutes.Otp);
              }
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'ລົງທະບຽນ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
