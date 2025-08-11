// lib/presentation/screens/login_screen.dart
// ໄຟລ໌ສຳລັບໜ້າຈໍເຂົ້າສູ່ລະບົບ

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:nav_service/nav_service.dart';

import '../widgets/phone_input_field.dart';
import '../widgets/password_input_field.dart';
import '../widgets/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool remember = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.failure) {}
      },
      builder: (context, state) {
        var cubit = context.read<AuthCubit>();
        var size = MediaQuery.of(context).size;

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              'ຍິນດີຕ້ອນຮັບ',
              style: TextStyle(color: Colors.black),
            ),
          ),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  // ຫົວຂໍ້ໜ້າເຂົ້າສູ່ລະບົບ
                  const Center(
                    child: Text(
                      'ເຂົ້າສູ່ລະບົບ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // ຂໍ້ຄວາມອະທິບາຍ
                  const Text(
                    'ປ້ອນໝາຍເລກໂທລະສັບຂອງທ່ານ ແລະ\nລະຫັດຜ່ານເພື່ອດຳເນີນການເຂົ້າສູ່ລະບົບ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  // ຊ່ອງປ້ອນເບີໂທລະສັບ
                  const PhoneInputField(),
                  const SizedBox(height: 16),
                  // ຊ່ອງປ້ອນລະຫັດຜ່ານ
                  const PasswordInputField(),
                  const SizedBox(height: 16),
                  // ເຊັກບັອກສ໌ ຈື່ໄວ້
                  Row(
                    children: [
                      Checkbox(
                        value: remember,
                        onChanged: (value) {
                          if (cubit.phoneNumber.text.isEmpty &&
                              cubit.password.text.isEmpty) {
                            setState(() {
                              remember = value!;
                            });
                          } else {
                            setState(() {
                              remember = value!;
                              cubit.saveLoginRemember(
                                phoneNumber: cubit.phoneNumber.text,
                                password: cubit.password.text,
                              );
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Text('ຈື່ໄວ້ຕະຫຼອດ'),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          NavService.pushNamed(AppRoutes.forgot);
                        },
                        child: const Text(
                          'ລືມລະຫັດຜ່ານ ?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // ປຸ່ມເຂົ້າສູ່ລະບົບ
                  const LoginButton(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(height: 1, width: 80, color: Colors.grey),
                        Text(
                          "ຫຼືເຂົ້າສູ່ລະບົບຜ່ານ",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Container(height: 1, width: 80, color: Colors.grey),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        cubit.signInWithGoogle();
                      },
                      child: Container(
                        height: size.height / 16,
                        width: size.width / 1.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child:
                            state.authStatus == AuthStatus.googleLoading
                                ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/google_ic.svg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      "ເຂົ້າສູ່ລະບົບດ້ວຍ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),

                  // ຂໍ້ຄວາມສຳລັບລົງທະບຽນຜູ້ໃຊ້ໃໝ່
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ທ່ານຍັງບໍ່ມີບັນຊີ ?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.Registerscreen,
                          );
                        },
                        child: const Text(
                          'ລົງທະບຽນຜູ້ໃຊ້ໃໝ່',
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
