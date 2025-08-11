// lib/presentation/pages/otp_verification_page.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/auth/presentation/forgot/widget/otp_forgot_pin.dart';
import 'package:m9/feature/auth/presentation/signup/otp/widget/otp_keyboard.dart';
import 'package:m9/feature/auth/presentation/signup/otp/widget/otp_pin.dart';
import 'package:pinput/pinput.dart';
import 'package:pinput/pinput.dart';

// ໜ້າຢືນຢັນລະຫັດ OTP
class OtpForgot extends StatefulWidget {
  const OtpForgot({super.key});

  @override
  State<OtpForgot> createState() => _OtpForgotState();
}

class _OtpForgotState extends State<OtpForgot> {
 
  final pinController = TextEditingController();

  Timer? _timer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _startOtpTimer(60);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startOtpTimer(int seconds) {
    _timer?.cancel();
    setState(() {
      _secondsLeft = seconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
        // TODO: optional callback when timer finished
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 0);
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

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
        final isRunning = _secondsLeft > 0;
        return Scaffold(
          appBar: AppBar(
            title: const Text('ກັບຄືນ', style: TextStyle(fontSize: 18)),
            leading: const BackButton(),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            children: [
              // ພື້ນທີ່ສ່ວນເທິງສຳລັບປ້ອນລະຫັດ OTP
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        // ຫົວຂໍ້
                        const Text(
                          'ຢືນຢັນລະຫັດ OTP',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // ຄຳອະທິບາຍ
                        Text(
                          'ລະບົບໄດ້ສົ່ງລະຫັດ OTP ໄປຫາເບີ 20${cubit.phoneNumber.text} ຂອງທ່ານແລ້ວ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 30),

                        state.authStatus == AuthStatus.loading
                            ? Center(child: CircularProgressIndicator())
                            : OtpForgotPin(),
                        // ຊ່ອງປ້ອນລະຫັດ OTP
                        const SizedBox(height: 30),
                        // ປຸ່ມສົ່ງລະຫັດໃໝ່
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ຍັງບໍ່ໄດ້ຮັບລະຫັດ? ',
                              style: TextStyle(fontSize: 16),
                            ),

                            InkWell(
                              onTap: () {
                                isRunning ? '' : Navigator.pop(context);
                              },
                              child: Text(
                                isRunning
                                    ? 'ເວລາເຫຼືອ ${_formatTime(_secondsLeft)}'
                                    : 'ສົ່ງໃໝ່ອີກຄັ້ງ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ຄີບອດສຳລັບປ້ອນຕົວເລກ
              OtpKeyboard(),
            ],
          ),
        );
      },
    );
  }
}
