// ignore_for_file: unnecessary_null_comparison
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  bool isCheck = false;
  var dataRemember;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final GoogleSignIn signIn = GoogleSignIn.instance;

  String _verificationId = '';
  int? _forceResendingToken;
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

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // ຜູ້ໃຊ້ cancel
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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

  Future<void> sendOTP({required String phoneNumber}) async {
    // set this to remove reCaptcha web
    //  forceRecaptchaFlowForTesting
    await auth.verifyPhoneNumber(
      phoneNumber: "+856${phoneNumber}",
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        //await mAuth.setSettings(forceRecaptchaFlow: true);
      },
      verificationFailed: (error) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
            error: error.toString(),
          ),
        );
      },
      codeSent: (verificationId, forceResendingToken) async {
        _verificationId = verificationId;
        _forceResendingToken = forceResendingToken;
      },
      forceResendingToken: _forceResendingToken,
      codeAutoRetrievalTimeout: (verificationId) async {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> verifyOTP() async {
    try {
      if (_verificationId == null || _verificationId == "") {
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
            error: 'ລະຫັດ otp ບໍ່ຖືກຕ້ອງ',
          ),
        );
      } else {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: pinController.text,
        );
        if (credential.smsCode == pinController.text) {
          // status == true ? await signInWithPhone(credential) : await resetOtp();
          signInWithPhone(credential);
        } else {
          emit(
            state.copyWith(
              authStatus: AuthStatus.failure,
              error: 'ເບີນີ້ມີຢູ່ໃນລະບົບແລ້ວ',
            ),
          );
        }
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), authStatus: AuthStatus.failure));
    }
  }

  Future<void> signInWithPhone(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await auth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        await Register(
          username: username.text,
          password: password.text,
          firstName: 'firstName',
          lastName: 'lastName',
          email: 'email',
          confirmPassword: 'confirmPassword',
          phoneNumber: phoneNumber.text,
        );
      } else {
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
            error: 'ເບີນີ້ມີຢູ່ໃນລະບົບແລ້ວ',
          ),
        );
      }
    } on FirebaseException catch (ex) {
      emit(
        state.copyWith(authStatus: AuthStatus.failure, error: ex.toString()),
      );
    }
  }
}
