// lib/domain/usecases/request_otp_usecase.dart
import 'package:m9/feature/auth/signup/otp/domain/repositories/otp_repository.dart';

// ກໍລະນີນຳໃຊ້ສຳລັບການຮ້ອງຂໍລະຫັດ OTP
class RequestOtpUseCase {
  final OtpRepository repository;
  
  RequestOtpUseCase(this.repository);
  
  Future<bool> execute(String phoneNumber) {
    return repository.requestOtp(phoneNumber);
  }
}
