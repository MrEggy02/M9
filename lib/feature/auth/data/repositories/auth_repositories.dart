import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:m9/core/data/network/api_status.dart';
import 'package:m9/feature/auth/data/service/auth_service.dart';
import 'package:m9/feature/auth/domain/models/bank_account_model.dart';
import 'package:m9/feature/auth/domain/models/user_model.dart';

class AuthRepositories {
  AuthService authService = AuthService();
  Future<Either<Failure, bool>> ResetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final reuslt = await authService.ResetPassword(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return right(reuslt);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> Forgot({required String phoneNumber}) async {
    try {
      final reuslt = await authService.Forgot(phoneNumber: phoneNumber);
      return right(reuslt);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> AvailablePhoneNumber({
    required String phoneNumber,
  }) async {
    try {
      final reuslt = await authService.AvailablePhoneNumber(
        phoneNumber: phoneNumber,
      );
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

  Future<Either<Failure, bool>> SignInWithGoogle({
    required String name,
    required String email,
    required String accessToken,
    required String googleId,
  }) async {
    try {
      final reuslt = await authService.SignInWithGoogle(
        name: name,
        email: email,
        accessToken: accessToken,
        googleId: googleId,
      );
      return right(reuslt);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> Register({
    required String username,
    required String password,

    required String confirmPassword,
    required String phoneNumber,
  }) async {
    try {
      final reuslt = await authService.Register(
        username: username,
        password: password,

        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
      );
      return right(reuslt);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> checkConnectivity() async {
    try {
      final result = await authService.checkConnectivity();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel?>> getProfile() async {
    try {
      final result = await authService.getProfile();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> editProfile({
    required String firstName,
    required String lastName,
    required String dob,
    required String phoneNumber,
    required String email,
    required String address,
    required String gender,
  }) async {
    try {
      final result = await authService.editProfile(
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        phoneNumber: phoneNumber,
        email: email,
        address: address,
        gender: gender,
      );
      return Right(result);
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
      final result = await authService.ChangePassword(
        oldPassword: oldPassword,
        password: password,
        confirmPassword: confirmPassword,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<BankAccount>>> getBankAccounts() async {
    try {
      final result = await authService.getBankAccounts();
      return Right(result!);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> addBankAccount({
    required String bankName,
    required String accountName,
    required String accountNo,
    required File image,
  }) async {
    try {
      final result = await authService.addBankAccount(
        bankName: bankName,
        accountName: accountName,
        accountNo: accountNo,
        image: image,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> editBankAccount({
    required String accountId,
    required String bankName,
    required String accountName,
    required String accountNo,
    String? image,
  }) async {
    try {
      final result = await authService.editBankAccount(
        accountId: accountId,
        bankName: bankName,
        accountName: accountName,
        accountNo: accountNo,
        image: image,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> deleteBankAccount({
    required String accountId,
  }) async {
    try {
      final result = await authService.deleteBankAccount(accountId: accountId);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
