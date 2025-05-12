// lib/domain/repositories/otp_repository.dart
abstract class OtpRepository {
  // ຮ້ອງຂໍລະຫັດ OTP
  Future<bool> requestOtp(String phoneNumber);
  
  // ຢືນຢັນລະຫັດ OTP
  Future<bool> verifyOtp(String phoneNumber, String otp);
}