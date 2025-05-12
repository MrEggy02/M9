// lib/presentation/screens/login_screen.dart
// ໄຟລ໌ສຳລັບໜ້າຈໍເຂົ້າສູ່ລະບົບ

import 'package:flutter/material.dart';
import 'package:m9/core/routes/app_routes.dart';
import '../../../signup/register/page/resister_screen.dart';
import '../widgets/phone_input_field.dart';
import '../widgets/password_input_field.dart';
import '../widgets/login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
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
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
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
                    value: false,
                    onChanged: (value) {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Text('ຈື່ໄວ້ຕະຫຼອດ'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'ລືມລະຫັດຜ່ານ ?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // ປຸ່ມເຂົ້າສູ່ລະບົບ
              const LoginButton(),
              const SizedBox(height: 60),
              // ຂໍ້ຄວາມສຳລັບລົງທະບຽນຜູ້ໃຊ້ໃໝ່
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ທ່ານຍັງບໍ່ມີບັນຊີ ?'),
                  TextButton(
                    onPressed: () {
          Navigator.pushReplacementNamed(context, AppRoutes.Registerscreen);
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
  }
}
