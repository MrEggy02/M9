// lib/presentation/widgets/register_button.dart
// ຄອມໂພເນັນສຳລັບປຸ່ມລົງທະບຽນ

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/auth/data/repositories/auth_repositories.dart';
import 'package:m9/feature/auth/presentation/signup/otp/widget/otp_pin.dart';
import 'package:m9/feature/usermode/presentation/setting/page/change/widget/otp.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

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
              if (cubit.username.text.isEmpty) {
                MessageHelper.showTopSnackBar(
                  context: context,
                  message: "ຊື່ຜູ້ໃຊ້ຫ້າມວ່າງ!",
                  isSuccess: false,
                );
                // } else if (cubit.firstName.text.isEmpty) {
                //   MessageHelper.showTopSnackBar(
                //     context: context,
                //     message: "ຊື່ຫ້າມວ່າງ!",
                //     isSuccess: false,
                //   );
                // } else if (cubit.lastName.text.isEmpty) {
                //   MessageHelper.showTopSnackBar(
                //     context: context,
                //     message: "ນາມສະກຸນຫ້າມວ່າງ!",
                //     isSuccess: false,
                //   );
              } else if (cubit.phoneNumber.text.isEmpty) {
                MessageHelper.showTopSnackBar(
                  context: context,
                  message: "ເບີໂທຫ້າມວ່າງ!",
                  isSuccess: false,
                );
                // } else if (!cubit.email.text.contains("@gmail.com")) {
                //   MessageHelper.showTopSnackBar(
                //     context: context,
                //     message: "ອີເມວຫ້າມວ່າງ!",
                //     isSuccess: false,
                //   );
              } else if (cubit.password.text.isEmpty) {
                MessageHelper.showTopSnackBar(
                  context: context,
                  message: "ລະຫັດຜ່ານຫ້າມວ່າງ!",
                  isSuccess: false,
                );
              } else if (cubit.password.text != cubit.comfirmpassword.text) {
                MessageHelper.showTopSnackBar(
                  context: context,
                  message: "ລະຫັດຜ້ານບໍ່ຕົງກັນ!",
                  isSuccess: false,
                );
              } else {
                cubit.Register(
                  username: cubit.username.text,
                  password: cubit.password.text,
                  confirmPassword: cubit.comfirmpassword.text,
                  phoneNumber: cubit.phoneNumber.text,
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
                    ? CircularProgressIndicator(color: Colors.black)
                    : const Text(
                      'ຢືນຢັນ',
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
