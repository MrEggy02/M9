// lib/data/datasources/otp_remote_datasource.dart
// ແຫຼ່ງຂໍ້ມູນຈາກເຊີບເວີ
abstract class OtpRemoteDataSource {
  Future<bool> requestOtp(String phoneNumber);
  Future<bool> verifyOtp(String phoneNumber, String otp);
}