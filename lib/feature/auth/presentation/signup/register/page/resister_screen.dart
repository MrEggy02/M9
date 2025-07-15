// lib/presentation/screens/register_screen.dart
// ໄຟລ໌ສຳລັບໜ້າຈໍລົງທະບຽນຜູ້ໃຊ້ໃໝ່

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import '../widgets/phone_input_field.dart';
import '../widgets/register_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  const SizedBox(height: 60),
                  // ຫົວຂໍ້ໜ້າລົງທະບຽນ
                  const Center(
                    child: Text(
                      'ລົງທະບຽນຜູ້ໃຊ້ໃໝ່',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // ຂໍ້ຄວາມອະທິບາຍ
                  const Text(
                    'ປ້ອນໝາຍເລກໂທລະສັບຂອງທ່ານ ເພື່ອລົງທະບຽນຜູ້ໃຊ້ໃໝ່',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  // ຊ່ອງປ້ອນເບີໂທລະສັບ
                  const PhoneInputField(),
                  const SizedBox(height: 16),
                  // ເຊັກບັອກສ໌ຍອມຮັບເງື່ອນໄຂ
                  _buildTermsCheckbox(cubit),
                  const SizedBox(height: 60),
                  // ປຸ່ມລົງທະບຽນ
                  const RegisterButton(),
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

  // ຟັງຊັນສຳລັບສ້າງເຊັກບັອກສ໌ຍອມຮັບເງື່ອນໄຂ
  Widget _buildTermsCheckbox(AuthCubit cubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: cubit.isCheck,
            onChanged: (value) {
              setState(() {
                cubit.isCheck = value!;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: Colors.amber),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            'ຂ້ອຍຍອມຮັບຂໍ້ກຳນົດແລະ ນະໂຍບາຍ',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
