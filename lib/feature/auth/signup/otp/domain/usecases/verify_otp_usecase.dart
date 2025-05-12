// lib/domain/usecases/verify_otp_usecase.dart
import 'package:m9/feature/auth/signup/otp/domain/repositories/otp_repository.dart';

// ກໍລະນີນຳໃຊ້ສຳລັບການຢືນຢັນລະຫັດ OTP
class VerifyOtpUseCase {
  final OtpRepository repository;
  
  VerifyOtpUseCase(this.repository);
  
  Future<bool> execute(String phoneNumber, String otp) {
    return repository.verifyOtp(phoneNumber, otp);
  }
}