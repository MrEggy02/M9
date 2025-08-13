// lib/presentation/screens/register_screen.dart
// ໄຟລ໌ສຳລັບໜ້າຈໍລົງທະບຽນຜູ້ໃຊ້ໃໝ່

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/usermode/presentation/setting/page/change/widget/phone_button_change_widget.dart';

import 'package:m9/feature/usermode/presentation/setting/page/change/widget/phone_change_widget.dart';

class ChangeNumber extends StatefulWidget {
  const ChangeNumber({super.key});

  @override
  State<ChangeNumber> createState() => _ChangeNumberState();
}

class _ChangeNumberState extends State<ChangeNumber> {
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
                      'ປ່ຽນເບີໂທລະສັບ',
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
                  const PhoneChangeWidget(),
                  const SizedBox(height: 16),

                  const SizedBox(height: 60),
                  // ປຸ່ມລົງທະບຽນ
                  const ChangePhoneButton(),
                  const SizedBox(height: 60),

                  // ຂໍ້ຄວາມສຳລັບເຂົ້າສູ່ລະບົບ
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
