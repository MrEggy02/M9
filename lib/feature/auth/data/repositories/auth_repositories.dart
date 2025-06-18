import 'package:dartz/dartz.dart';
import 'package:m9/core/data/network/api_status.dart';
import 'package:m9/feature/auth/data/service/auth_service.dart';

class AuthRepositories {
  AuthService authService = AuthService();

  Future<Either<Failure, dynamic>> getProfile() async {
    try {
      final reuslt = await authService.getProfile();
      return right(reuslt);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> Login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final reuslt = await authService.Login(
        phoneNumber: phoneNumber,
        password: password,
      );
      return right(reuslt);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> Register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    try {
      final reuslt = await authService.Register(
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
        email: email,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
      );
      return right(reuslt);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> ChangePassword({
    required String oldPassword,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final reuslt = await authService.ChangePassword(
        oldPassword: oldPassword,
        password: password,
        confirmPassword: confirmPassword,
      );
      return right(reuslt);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
