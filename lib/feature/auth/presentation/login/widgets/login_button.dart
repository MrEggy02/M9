import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/core/data/response/messageHelper.dart';

import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

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
              } else if (cubit.password.text.isEmpty) {
                MessageHelper.showTopSnackBar(
                  context: context,
                  message: "ລະຫັດຜ່ານຫ້າມວ່າງ",
                  isSuccess: false,
                );
              } else {
                cubit.Login(
                  phoneNumber: cubit.phoneNumber.text,
                  password: cubit.password.text,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                state.authStatus == AuthStatus.loading
                    ? Center(child: CircularProgressIndicator(color: AppColors.primaryColorBlack,))
                    : const Text(
                      'ເຂົ້າສູ່ລະບົບ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        );
      },
    );
  }
}
