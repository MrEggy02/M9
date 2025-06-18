// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:m9/core/data/hive/hive_database.dart';
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
  final formKeyLogin = GlobalKey<FormState>();

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController comfirmpassword = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController pinController = TextEditingController();
  var dataRemember;
  @override
  Future<void> close() {
    mounted = false;
    return super.close();
  }

  clear() {
    phoneNumber.clear();
    password.clear();
    newpassword.clear();
    comfirmpassword.clear();
    username.clear();
  }

  Future<void> saveLoginRemember({
    required String phoneNumber,
    required String password,
  }) async {
    await HiveDatabase.saveLoginRemember(
      phoneNumber: "20" + phoneNumber,
      password: password,
    );
  }

  Future<void> getProfile() async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    final result = await authRepositories.getProfile();
    result.fold(
      (error) {
        emit(state.copyWith(authStatus: AuthStatus.failure));
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: error.toString(),
        );
      },
      (success) {
        emit(state.copyWith(authStatus: AuthStatus.success));
      },
    );
  }

  Future<void> Login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      var result = await authRepositories.Login(
        phoneNumber: '20' + phoneNumber,
        password: password,
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
          clear();
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
