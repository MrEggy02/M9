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

  Future<Either<Failure, bool?>> getMe() async {
    try {
      final result = await authService.getMe();

      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> updateProfile({required File avatar}) async {
    try {
      final result = await authService.updateProfile(avatar: avatar);
      if (result != true) {
        return Left(Failure("Error"));
      }
      return right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> updateUser({
    required String firstName,
    required String lastName,
    required String dob,
    required String username,
    required String email,
    required String address,
    required String gender,
  }) async {
    try {
      final result = await authService.updateUser(
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        email: email,
        address: address,
        gender: gender,
        username: username,
      );
      if (result != true) {
        return Left(Failure("Error"));
      }
      return right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> ChangePhoneNumber({
    required String newPhoneNumber,
    required String googleToken,
  }) async {
    try {
      final result = await authService.ChangePhoneNumber(
        newPhoneNumber: newPhoneNumber,
        googleToken: googleToken,
      );
      if (result != true) {
        return Left(Failure("Error"));
      }
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
      if (result != true) {
        return Left(Failure("Error"));
      }
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
  
//bankaccount part 
  Future<Either<Failure, BankAccount>> getBankAccount() async {
    try {
      final result = await authService.getBankAccount();
      if (result == null) {
        return Left(Failure('No bank account found'));
      }
      return Right(result);
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

  Future<Either<Failure, BankAccount>> updateBankAccount(
    BankAccount account,
  ) async {
    try {
      final result = await authService.updateBankAccount(account);
      if (result == null) return Left(Failure('Update failed'));
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

}
