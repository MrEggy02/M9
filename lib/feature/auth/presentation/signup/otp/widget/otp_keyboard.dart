// lib/presentation/widgets/otp_keyboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';

// ວິດເຈັດສຳລັບປຸ່ມກົດຕົວເລກ
class OtpKeyboard extends StatelessWidget {
  const OtpKeyboard({super.key});

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
        return Container(
          color: Colors.grey.shade200,
          child: Column(
            children: [
              buildKeyboardRow(['1', '2', '3'], cubit),
              buildKeyboardRow(['4', '5', '6'], cubit),
              buildKeyboardRow(['7', '8', '9'], cubit),
              buildKeyboardRow(['', '0', 'backspace'], cubit),
              const SizedBox(height: 20), // ເພີ່ມຊ່ອງຫວ່າງທາງລຸ່ມ
            ],
          ),
        );
      },
    );
  }

  // ສ້າງແຖວຂອງປຸ່ມກົດ
  Widget buildKeyboardRow(List<String> keys, AuthCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => buildKeyboardButton(key, cubit)).toList(),
    );
  }

  // ສ້າງປຸ່ມກົດແຕ່ລະປຸ່ມ
  Widget buildKeyboardButton(String key, AuthCubit cubit) {
    if (key.isEmpty) {
      return const SizedBox(width: 80, height: 80);
    }

    if (key == 'backspace') {
      return SizedBox(
        width: 80,
        height: 80,
        child: InkWell(
          onTap: () {
            if (cubit.pinController.text.isEmpty) {
            } else {
              cubit.pinController.text = cubit.pinController.text.substring(
                0,
                cubit.pinController.text.length - 1,
              );
              print("====>${cubit.pinController.text}");
            }
          },
          child: const Center(child: Icon(Icons.backspace_outlined)),
        ),
      );
    }

    // ສ້າງປຸ່ມຕົວເລກ
    return SizedBox(
      width: 80,
      height: 80,
      child: TextButton(
        // onPressed: () => onKeyPressed(key),
        onPressed: () {
          cubit.pinController.text += key;
          print("====>${cubit.pinController.text}");
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              key,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // ເພີ່ມຕົວອັກສອນໃຕ້ຕົວເລກ (ຍົກເວັ້ນເລກ 1 ແລະ 0)
            if (key != '1' && key != '0')
              Text(
                getSubtitleForNumber(key),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }

  // ດຶງຕົວອັກສອນທີ່ສອດຄ່ອງກັບຕົວເລກ
  String getSubtitleForNumber(String number) {
    switch (number) {
      case '2':
        return 'A B C';
      case '3':
        return 'D E F';
      case '4':
        return 'G H I';
      case '5':
        return 'J K L';
      case '6':
        return 'M N O';
      case '7':
        return 'P Q R S';
      case '8':
        return 'T U V';
      case '9':
        return 'W X Y Z';
      default:
        return '';
    }
  }
}
