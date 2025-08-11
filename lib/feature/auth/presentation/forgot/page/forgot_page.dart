// lib/presentation/screens/register_screen.dart
// ໄຟລ໌ສຳລັບໜ້າຈໍລົງທະບຽນຜູ້ໃຊ້ໃໝ່

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/auth/presentation/forgot/widget/forgot_button_widget.dart';
import 'package:m9/feature/auth/presentation/forgot/widget/phone_forgot.dart';
import 'package:m9/feature/auth/presentation/signup/register/widgets/phone_input_field.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
 



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('ກັບຄືນ', style: TextStyle(color: Colors.black)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  // ຫົວຂໍ້ໜ້າລົງທະບຽນ
                  const Center(
                    child: Text(
                      'ລືມລະຫັດຜ່ານ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // ຂໍ້ຄວາມອະທິບາຍ
                  const Text(
                    'ປ້ອນໝາຍເລກໂທລະສັບຂອງທ່ານ ເພື່ອຮັບ OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  // ຊ່ອງປ້ອນເບີໂທລະສັບ
                  const PhoneForgot(),
                  const SizedBox(height: 16),

                  const SizedBox(height: 60),
                  // ປຸ່ມລົງທະບຽນ
                  const ForgotButton(),
                  const SizedBox(height: 60),
                  // ຂໍ້ຄວາມສຳລັບເຂົ້າສູ່ລະບົບ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ມີບັນຊີແລ້ວ ?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'ເຂົ້າສູ່ລະບົບ',
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'M9 Driver V 1.1.1',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
