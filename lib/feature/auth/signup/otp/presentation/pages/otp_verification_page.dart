// lib/presentation/pages/otp_verification_page.dart
import 'package:flutter/material.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/auth/signup/otp/presentation/controllers/otp_controller.dart';
import 'package:m9/feature/auth/signup/otp/presentation/widgets/otp_input_field.dart';
import 'package:m9/feature/auth/signup/otp/presentation/widgets/otp_keyboard.dart';
// ໜ້າຢືນຢັນລະຫັດ OTP
class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key, String? phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // ສ້າງຕົວຄວບຄຸມ OTP
  late final OtpController _otpController;
  
  @override
  void initState() {
    super.initState();
    _otpController = OtpController(
      phoneNumber: '20 98763987',
      onOtpCompleted: (otp) {
        // ເມື່ອປ້ອນ OTP ຄົບແລ້ວ, ສົ່ງໄປກວດສອບກັບ API ແລະ ນຳທາງໄປຫນ້າຖັດໄປ
        debugPrint('OTP completed: $otp');
        // ຈຳລອງການກວດສອບສຳເລັດ ແລະ ນຳທາງໄປຫນ້າຖັດໄປ
        _verifyAndNavigate(otp);
      }
    );
  }
  
  // ກວດສອບ OTP ແລະ ນຳທາງໄປຫນ້າຖັດໄປ
  void _verifyAndNavigate(String otp) {
    // ສະແດງໂຫລດດິ້ງໃນຂະນະທີ່ກວດສອບ
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.amber)),
    );
    
    // ຈຳລອງການກວດສອບກັບເຊີເວີ (ໃນສະຖານະການຈິງຄວນໃຊ້ API)
    Future.delayed(const Duration(seconds: 1), () {
      // ປິດໂຫລດດິ້ງ
      Navigator.pop(context);
      
      // ນຳທາງໄປຫນ້າຖັດໄປ
          Navigator.pushReplacementNamed(context, AppRoutes.user);
    });
  }
  
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ກັບຄືນ', style: TextStyle(fontSize: 18)),
        leading: const BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ພື້ນທີ່ສ່ວນເທິງສຳລັບປ້ອນລະຫັດ OTP
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    // ຫົວຂໍ້
                    const Text(
                      'ຢືນຢັນລະຫັດ OTP',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // ຄຳອະທິບາຍ
                    Text(
                      'ລະບົບໄດ້ສົ່ງລະຫັດ OTP ໄປຫາເບີ ${_otpController.phoneNumber} ຂອງທ່ານແລ້ວ',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // ຊ່ອງປ້ອນລະຫັດ OTP
                    OtpInputField(controller: _otpController),
                    const SizedBox(height: 30),
                    // ປຸ່ມສົ່ງລະຫັດໃໝ່
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ຍັງບໍ່ໄດ້ຮັບລະຫັດ? ',
                          style: TextStyle(fontSize: 16),
                        ),
                        InkWell(
                          onTap: _otpController.resendOtp,
                          child: const Text(
                            'ສົ່ງໃໝ່ອີກຄັ້ງ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ຄີບອດສຳລັບປ້ອນຕົວເລກ
          OtpKeyboard(onKeyPressed: _otpController.onKeyPressed),
        ],
      ),
    );
  }
}