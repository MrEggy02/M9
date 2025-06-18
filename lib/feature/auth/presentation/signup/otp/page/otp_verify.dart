// lib/presentation/pages/otp_verification_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/auth/presentation/signup/otp/widget/otp_keyboard.dart';
import 'package:m9/feature/auth/presentation/signup/otp/widget/otp_pin.dart';
import 'package:pinput/pinput.dart';
import 'package:pinput/pinput.dart';

// ໜ້າຢືນຢັນລະຫັດ OTP
class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // ກວດສອບ OTP ແລະ ນຳທາງໄປຫນ້າຖັດໄປ
  void _verifyAndNavigate(String otp) {
    // ສະແດງໂຫລດດິ້ງໃນຂະນະທີ່ກວດສອບ
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          ),
    );

    // ຈຳລອງການກວດສອບກັບເຊີເວີ (ໃນສະຖານະການຈິງຄວນໃຊ້ API)
    Future.delayed(const Duration(seconds: 1), () {
      // ປິດໂຫລດດິ້ງ
      Navigator.pop(context);

      // ນຳທາງໄປຫນ້າຖັດໄປ
      Navigator.pushReplacementNamed(context, AppRoutes.user);
    });
  }

  final pinController = TextEditingController();
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

                        OtpPin(),
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
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'ສົ່ງໃໝ່ອີກຄັ້ງ',
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
