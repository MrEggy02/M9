// lib/data/repositories/otp_repository_impl.dart
import 'package:m9/feature/auth/signup/otp/data/datasources/otp_remote_datasource.dart';
import 'package:m9/feature/auth/signup/otp/domain/repositories/otp_repository.dart';

// ການຈັດຕັ້ງປະຕິບັດຂອງ OTP Repository
class OtpRepositoryImpl implements OtpRepository {
  final OtpRemoteDataSource remoteDataSource;
  
  OtpRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<bool> requestOtp(String phoneNumber) {
    return remoteDataSource.requestOtp(phoneNumber);
  }
  
  @override
  Future<bool> verifyOtp(String phoneNumber, String otp) {
    return remoteDataSource.verifyOtp(phoneNumber, otp);
  }
}