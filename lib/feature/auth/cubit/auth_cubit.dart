// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/auth/data/repositories/auth_repositories.dart';
import 'package:nav_service/nav_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final BuildContext context;
  final AuthRepositories authRepositories;
  AuthCubit({required this.context, required this.authRepositories})
    : super(const AuthState(authStatus: AuthStatus.initial));

  bool mounted = true;
  bool isStart = false;
  int currenIndex = 0;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController comfirmpassword = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController oldImage = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accountName = TextEditingController();
  TextEditingController accountNo = TextEditingController();
  @override
  Future<void> close() {
    mounted = false;
    return super.close();
  }

  Future<void> Login({
    required String username,
    required String password,
  }) async {
    try {
      var result = await authRepositories.Login(
        username: username,
        password: password,
      );
      result.fold(
        (f) {
          emit(state.copyWith(
              authStatus: AuthStatus.failure, 
              error: f.toString()),
          );
          MessageHelper.showSnackBarMessage(
            isSuccess: false,
            message: f.toString(),
          );
        },
        (success) {
          emit(state.copyWith(authStatus: AuthStatus.success));
          NavService.pushNamed(AppRoutes.homepage);
        },
      );
    } catch (e) {
      emit(state.copyWith(authStatus: AuthStatus.failure, error: e.toString()));
    }
  }

  Future<void> Register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    try {
      var result = await authRepositories.Register(
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
        email: email,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
      );
      result.fold(
        (f) {
          emit(
            state.copyWith(authStatus: AuthStatus.failure, error: f.toString()),
          );
          MessageHelper.showSnackBarMessage(
            isSuccess: false,
            message: f.toString(),
          );
        },
        (success) {
          emit(state.copyWith(authStatus: AuthStatus.success));
        },
      );
    } catch (e) {
      emit(state.copyWith(authStatus: AuthStatus.failure, error: e.toString()));
    }
  }

  Future<void> ChangePassword({
    required String oldPassword,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      var result = await authRepositories.ChangePassword(
        oldPassword: oldPassword,
        password: password,
        confirmPassword: confirmPassword,
      );
      result.fold(
        (f) {
          emit(
            state.copyWith(authStatus: AuthStatus.failure, error: f.toString()),
          );
          MessageHelper.showSnackBarMessage(
            isSuccess: false,
            message: f.toString(),
          );
        },
        (success) {
          emit(state.copyWith(authStatus: AuthStatus.success));
        },
      );
    } catch (e) {
      emit(state.copyWith(authStatus: AuthStatus.failure, error: e.toString()));
    }
  }
}
