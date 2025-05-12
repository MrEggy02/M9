// lib/presentation/controllers/otp_controller.dart
import 'package:flutter/material.dart';

// ຄລາສຄວບຄຸມການຈັດການລະຫັດ OTP
class OtpController extends ChangeNotifier {
  final String phoneNumber;
  final Function(String) onOtpCompleted;
  
  String _otp = '';
  
  OtpController({
    required this.phoneNumber,
    required this.onOtpCompleted,
  });
  
  String get otp => _otp;
  
  // ຮັບຄ່າຕົວເລກທີ່ກົດຈາກຄີບອດ
  void onKeyPressed(String key) {
    if (key == 'backspace') {
      if (_otp.isNotEmpty) {
        _otp = _otp.substring(0, _otp.length - 1);
        notifyListeners();
      }
    } else if (_otp.length < 6) {
      _otp += key;
      notifyListeners();
      
      // ຖ້າປ້ອນຄົບ 6 ຕົວແລ້ວ, ແຈ້ງເຕືອນໄປຫາຜູ້ຮັບຟັງ
      if (_otp.length == 6) {
        onOtpCompleted(_otp);
      }
    }
  }
  
  // ສົ່ງລະຫັດໃໝ່
  void resendOtp() {
    // ລີເຊັດຄ່າ OTP
    _otp = '';
    notifyListeners();
    
    // ຕາມປົກກະຕິຈະມີການເອີ້ນໃຊ້ API ເພື່ອຮ້ອງຂໍລະຫັດໃໝ່
    debugPrint('Resending OTP to $phoneNumber');
  }
}