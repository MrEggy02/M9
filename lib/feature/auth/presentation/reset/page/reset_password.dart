import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/auth/presentation/reset/widget/reset_password_button.dart';
import 'package:m9/feature/auth/presentation/signup/confirm/widget/confirmpassword_widget.dart';

import 'package:m9/feature/auth/presentation/signup/confirm/widget/password_widget.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.failure) {
          print('reset error=>${state.error}');
        }
      },
      builder: (context, state) {
        var cubit = context.read<AuthCubit>();

        return Scaffold(
          key: scaffoldKey,
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
                      'ສ້າງລະຫັດຜ່ານໃໝ່',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  PasswordWidget(),
                  const SizedBox(height: 16),
                  ConfirmPasswordWidget(),
                  const SizedBox(height: 60),
                  ResetPasswordButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
