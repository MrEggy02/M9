// lib/presentation/widgets/otp_keyboard.dart
import 'package:flutter/material.dart';

// ວິດເຈັດສຳລັບປຸ່ມກົດຕົວເລກ
class OtpKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  
  const OtpKeyboard({
    super.key,
    required this.onKeyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          buildKeyboardRow(['1', '2', '3']),
          buildKeyboardRow(['4', '5', '6']),
          buildKeyboardRow(['7', '8', '9']),
          buildKeyboardRow(['', '0', 'backspace']),
          const SizedBox(height: 20), // ເພີ່ມຊ່ອງຫວ່າງທາງລຸ່ມ
        ],
      ),
    );
  }

  // ສ້າງແຖວຂອງປຸ່ມກົດ
  Widget buildKeyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => buildKeyboardButton(key)).toList(),
    );
  }

  // ສ້າງປຸ່ມກົດແຕ່ລະປຸ່ມ
  Widget buildKeyboardButton(String key) {
    if (key.isEmpty) {
      return const SizedBox(width: 80, height: 80);
    }
    
    if (key == 'backspace') {
      return SizedBox(
        width: 80,
        height: 80,
        child: InkWell(
          onTap: () => onKeyPressed('backspace'),
          child: const Center(
            child: Icon(Icons.backspace_outlined),
          ),
        ),
      );
    }
    
    // ສ້າງປຸ່ມຕົວເລກ
    return SizedBox(
      width: 80,
      height: 80,
      child: TextButton(
        onPressed: () => onKeyPressed(key),
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
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ດຶງຕົວອັກສອນທີ່ສອດຄ່ອງກັບຕົວເລກ
  String getSubtitleForNumber(String number) {
    switch (number) {
      case '2': return 'A B C';
      case '3': return 'D E F';
      case '4': return 'G H I';
      case '5': return 'J K L';
      case '6': return 'M N O';
      case '7': return 'P Q R S';
      case '8': return 'T U V';
      case '9': return 'W X Y Z';
      default: return '';
    }
  }
}