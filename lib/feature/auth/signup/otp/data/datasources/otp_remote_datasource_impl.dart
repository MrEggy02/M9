// lib/data/datasources/otp_remote_datasource_impl.dart
import 'package:m9/feature/auth/signup/otp/data/datasources/otp_remote_datasource.dart';

// ການຈັດຕັ້ງປະຕິບັດຂອງ OTP Remote Data Source
class OtpRemoteDataSourceImpl implements OtpRemoteDataSource {
  // ສົມມຸດວ່າມີ Http client ຫຼື API ເຊີວິດ
  
  @override
  Future<bool> requestOtp(String phoneNumber) async {
    // ຕາມປົກກະຕິຈະເຮັດການຮ້ອງຂໍ API
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
  
  @override
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    // ຕາມປົກກະຕິຈະເຮັດການຮ້ອງຂໍ API
    await Future.delayed(const Duration(seconds: 2));
    return true; // ສົມມຸດວ່າ OTP ຖືກຕ້ອງສະເໝີເພື່ອໃຫ້ການສາທິດລຽນໄຫຼໄດ້ດີ
  }
}