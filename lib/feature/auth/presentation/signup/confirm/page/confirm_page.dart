import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';

import 'package:m9/feature/auth/presentation/signup/confirm/widget/confirmpassword_widget.dart';
import 'package:m9/feature/auth/presentation/signup/confirm/widget/createAccount.dart';

import 'package:m9/feature/auth/presentation/signup/confirm/widget/password_widget.dart';
import 'package:m9/feature/auth/presentation/signup/confirm/widget/username_widget.dart';

class ConfirmPage extends StatefulWidget {
  const ConfirmPage({super.key});

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
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
                  const SizedBox(height: 20),
                  // ຫົວຂໍ້ໜ້າລົງທະບຽນ
                  const Center(
                    child: Text(
                      'ສ້າງບັນຊີຜູ້ໃຊ້ໃໝ່',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // ຂໍ້ຄວາມອະທິບາຍ
                  const Text(
                    'ປ້ອນຂໍ້ມູນສ່ວນຕົວ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  UsernameWidget(),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  PasswordWidget(),
                  const SizedBox(height: 16),
                  ConfirmPasswordWidget(),
                  const SizedBox(height: 60),
                  CreateAccount(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
