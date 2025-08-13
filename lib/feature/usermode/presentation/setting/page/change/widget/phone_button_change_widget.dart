// lib/presentation/widgets/register_button.dart
// ຄອມໂພເນັນສຳລັບປຸ່ມລົງທະບຽນ

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/usermode/presentation/setting/page/change/widget/otp.dart';

class ChangePhoneButton extends StatelessWidget {
  const ChangePhoneButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.failure) {
          print('forgot error=>${state.error}');
        }
      },
      builder: (context, state) {
        var cubit = context.read<AuthCubit>();

        return 
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (cubit.isPhone == false) {
                MessageHelper.showTopSnackBar(
                  context: context,
                  message: "ຕ້ອງຢືນຢັນເບີໂທກ່ອນ!",
                  isSuccess: false,
                );
              } else {
                cubit.sendOTP(phoneNumber: cubit.phoneNumber.text);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpChangePhone()));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  cubit.isPhone == false ? Colors.grey.shade300 : Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                state.authStatus == AuthStatus.loading
                    ? CircularProgressIndicator(color: Colors.black)
                    : const Text(
                      'ຂໍລະຫັດ OTP',
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
