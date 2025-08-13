import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:pinput/pinput.dart';

class OtpPinChangePhone extends StatefulWidget {
  const OtpPinChangePhone({super.key});

  @override
  State<OtpPinChangePhone> createState() => _OtpPinChangePhoneState();
}

class _OtpPinChangePhoneState extends State<OtpPinChangePhone> {
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
        return Pinput(
          controller: cubit.pinController,
          length: 6,
          autofocus: true,
          readOnly: true,
          keyboardType: TextInputType.phone,
          defaultPinTheme: PinTheme(
            width: 56,
            height: 60,
            textStyle: TextStyle(fontSize: 20, color: Colors.black),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryColor),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 56,
            height: 60,
            textStyle: TextStyle(fontSize: 20, color: Colors.black),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryColor, width: 2),
            ),
          ),
          submittedPinTheme: PinTheme(
            width: 56,
            height: 60,
            textStyle: TextStyle(
              fontSize: 20,
              color: AppColors.primaryColorBlack,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryColor),
            ),
          ),
          errorPinTheme: PinTheme(
            width: 56,
            height: 60,
            textStyle: TextStyle(fontSize: 20, color: Colors.red),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red, width: 2),
            ),
          ),
          onCompleted: (pin) {
            print('Entered pin: $pin');
            cubit.verifyChangeOTP().then((value) {
              // if (value == 1) {
              //   cubit.sumitOTP();
              // }
            });
          },
        );
      },
    );
  }
}
