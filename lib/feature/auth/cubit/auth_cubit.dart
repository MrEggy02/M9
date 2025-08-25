// ignore_for_file: unnecessary_null_comparison
import 'dart:io';

// ignore: unused_import
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn;
import 'package:image_picker/image_picker.dart';

import 'package:m9/core/data/hive/hive_database.dart';
// ignore: unused_import
import 'package:m9/core/data/network/api_status.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/auth/data/repositories/auth_repositories.dart';
import 'package:m9/feature/auth/domain/models/bank_account_model.dart';
// ignore: unused_import
import 'package:m9/feature/auth/presentation/reset/page/reset_password.dart';
import 'package:nav_service/nav_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final BuildContext context;
  final AuthRepositories authRepositories;
  AuthCubit({required this.context, required this.authRepositories})
    : super(const AuthState(authStatus: AuthStatus.initial));

  bool mounted = true;
  bool isStart = false;
  int currenIndex = 0;

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController newPhoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController comfirmpassword = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController bankIdController = TextEditingController();

  bool isCheck = false;
  bool isPhone = false;
  String? selectedGender;
  final ImagePicker _picker = ImagePicker();
  var dataRemember;

  final FirebaseAuth auth = FirebaseAuth.instance;
  // final GoogleSignIn signIn = GoogleSignIn.instance;

  String _verificationId = '';
  // ignore: unused_field
  int? _forceResendingToken;
  @override
  Future<void> close() {
    dobController.dispose();
    mounted = false;
    return super.close();
  }

  void checkPhone(phone) {
    isPhone = phone;
    emit(state.copyWith(isCheck: isPhone));
  }

  void onCheck(check) {
    isCheck = check;
    emit(state.copyWith(isCheck: check));
  }

  clear() {
    phoneNumber.clear();
    password.clear();
    newpassword.clear();
    comfirmpassword.clear();
    username.clear();
    email.clear();
    firstName.clear();
    lastName.clear();
    newPhoneNumber.clear();
  }

  Future<void> saveLoginRemember({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      await HiveDatabase.saveLoginRemember(
        phoneNumber: phoneNumber,
        password: password,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUser({
    required String firstName,
    required String lastName,
    required String dob,
    required String username,
    required String email,
    required String address,
    required String gender,
  }) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));

    try {
      final result = await authRepositories.updateUser(
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        username: username,
        email: email,
        address: address,
        gender: gender,
      );

      result.fold(
        (error) => _handleFailure(error.toString()),
        (success) =>
            success
                ? _handleSuccess()
                : _handleFailure("Failed to update profile"),
      );
    } catch (e) {
      _handleFailure(e.toString());
    }
  }
void clearUpdateFlag() {
  emit(state.copyWith(isUpdate: false));
}

 void _handleSuccess() async {
  await getProfile();
  emit(state.copyWith(
    authStatus: AuthStatus.success,
    isUpdate: true, 
  ));
  MessageHelper.showSnackBarMessage(
    isSuccess: true,
    message: "Profile updated successfully",
  );
}


  void _handleFailure(String error) {
    emit(state.copyWith(authStatus: AuthStatus.failure, error: error));
    MessageHelper.showSnackBarMessage(isSuccess: false, message: error);
  }

  Future<void> updateProfile({required File avatar}) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    final result = await authRepositories.updateProfile(avatar: avatar);
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
        getProfile();
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    final file = File(pickedFile!.path);
    if (pickedFile != null) {
      updateProfile(avatar: file);
      // Do something with the picked image
      // print("Picked image: ${pickedFile.path}");

      Navigator.of(context).pop(); // close dialog
    }
  }

  void showAddPhotoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Photo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Take Photo"),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Choose from Gallery"),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(state.copyWith(authStatus: AuthStatus.googleLoading));
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final googleUser = await googleSignIn.authenticate();
      if (googleUser == null) {
        print("❌ googleUser is null");
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: "❌ googleUser is null",
        );
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        print("❌ idToken is null");
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: "❌ idToken is null",
        );
      }

      final authorization = await googleUser.authorizationClient
          .authorizationForScopes(['email']);
      final accessToken = authorization?.accessToken;

      if (accessToken == null) {
        print("❌ accessToken is null");
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: "❌ accessToken is null",
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: accessToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((success) async {
            final token = await success.user!.getIdToken();
            print("===>${await token.toString()}");
            SiginInWithGoogle(
              name: success.user!.displayName.toString(),
              googleId: success.user!.uid.toString(),
              email: success.user!.email.toString(),
              accessToken: await token.toString(),
            );
          })
          .catchError((err) {
            MessageHelper.showSnackBarMessage(
              isSuccess: false,
              message: "Faild Login By Google Success $err",
            );
          });
    } catch (e, stack) {
      print("Google Sign-In error: $e");
      MessageHelper.showSnackBarMessage(
        isSuccess: false,
        message: "Google Sign-In error: $e",
      );
      print(stack);
    }
  }

  Future<void> getMe() async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    final result = await authRepositories.getMe();
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

  Future<void> getProfile() async {
    emit(state.copyWith(authStatus: AuthStatus.loading));

    try {
      final result = await authRepositories.getProfile();

      result.fold(
        (error) {
          emit(
            state.copyWith(
              authStatus: AuthStatus.failure,
              error: error.toString(),
            ),
          );
        },
        (user) {
          emit(state.copyWith(authStatus: AuthStatus.success, userModel: user));
        },
      );
    } catch (e) {
      emit(state.copyWith(authStatus: AuthStatus.failure, error: e.toString()));
    }
  }

  Future<void> Forgot({required String phoneNumber}) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    var result = await authRepositories.Forgot(phoneNumber: '20' + phoneNumber);
    result.fold(
      (f) {
        emit(state.copyWith(authStatus: AuthStatus.failure));
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: "ເບີທ່ານບໍ່ຖືກຕ້ອງ",
        );
      },
      (success) {
        isPhone = true;
        emit(state.copyWith(authStatus: AuthStatus.success));
        MessageHelper.showSnackBarMessage(
          isSuccess: true,
          message: "ຢືນຢັນເບີສຳເລັດ",
        );
      },
    );
  }

  Future<void> AvailablePhoneNumber({required String phoneNumber}) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    var result = await authRepositories.AvailablePhoneNumber(
      phoneNumber: '20' + phoneNumber,
    );
    result.fold(
      (f) {
        emit(
          state.copyWith(authStatus: AuthStatus.failure, error: f.toString()),
        );
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: "ເບີນີ້ເຄີຍລົງທະບຽນແລ້ວ",
        );
      },
      (success) {
        isPhone = true;
        emit(state.copyWith(authStatus: AuthStatus.success));
        MessageHelper.showSnackBarMessage(
          isSuccess: true,
          message: "ເບີນີ້ໃຊ້ງານໄດ້",
        );
      },
    );
  }

  Future<void> ResetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      var result = await authRepositories.ResetPassword(
        newPassword: newPassword,
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
          NavService.pushReplacementNamed(AppRoutes.login);
          clear();
          MessageHelper.showSnackBarMessage(
            isSuccess: true,
            message: "ປ່ຽນລະຫັດຜ່ານສຳເລັດ",
          );
          emit(state.copyWith(authStatus: AuthStatus.success));
        },
      );
    } catch (e) {
      emit(state.copyWith(authStatus: AuthStatus.failure, error: e.toString()));
    }
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
            message: "ເບີໂທຫລືລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ",
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

  Future<void> SiginInWithGoogle({
    required String name,
    required String email,
    required String accessToken,
    required String googleId,
  }) async {
    emit(state.copyWith(authStatus: AuthStatus.googleLoading));
    final result = await authRepositories.SignInWithGoogle(
      googleId: googleId,
      email: email,
      name: name,
      accessToken: accessToken,
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
  }

  Future<void> Register({
    required String username,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    var result = await authRepositories.Register(
      username: username,
      password: password,

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
        NavService.pushReplacementNamed(AppRoutes.homepage);
        clear();
        emit(state.copyWith(authStatus: AuthStatus.success));
      },
    );
  }

  Future<void> ChangePhoneNumber({
    required String newPhoneNumber,
    required String googleToken,
  }) async {
    try {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      var result = await authRepositories.ChangePhoneNumber(
        newPhoneNumber: newPhoneNumber,
        googleToken: googleToken,
      );
      result.fold(
        (f) {
          emit(
            state.copyWith(authStatus: AuthStatus.failure, error: f.toString()),
          );
          MessageHelper.showSnackBarMessage(
            isSuccess: false,
            message: "ຜິດພາດ",
          );
        },
        (success) async {
          clear();
          await getMe();
          emit(state.copyWith(authStatus: AuthStatus.success));

          getProfile();
          NavService.pushReplacementNamed(AppRoutes.homepage);
          MessageHelper.showSnackBarMessage(
            isSuccess: true,
            message: "ປ່ຽນເບີໂທສຳເລັດ",
          );
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
      emit(state.copyWith(authStatus: AuthStatus.loading));
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
    try {
      // ຕັ້ງຄ່າ timeout ຫຍາວຂື້ນ
      await auth.verifyPhoneNumber(
        phoneNumber: "+85620${phoneNumber}",
        timeout: const Duration(seconds: 60), // 2 ນາທີ

        verificationCompleted: (PhoneAuthCredential credential) async {
          print("Auto verification completed");
          try {
            //  await auth.signInWithCredential(credential);
            emit(state.copyWith(authStatus: AuthStatus.success));
          } catch (e) {
            print("Auto sign in failed: $e");
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.code} - ${e.message}");

          // ແກ້ໄຂຂໍ້ຜິດພາດສະເພາະ
          if (e.code == 'too-many-requests') {
            emit(
              state.copyWith(
                authStatus: AuthStatus.failure,
                error: "ທ່ານໄດ້ລອງຫຼາຍຄັ້ງເກີນໄປ. ກະລຸນາລໍຖ້າ 1 ຊົ່ວໂມງ",
              ),
            );
            MessageHelper.showSnackBarMessage(
              isSuccess: false,
              message: "ທ່ານໄດ້ລອງຫຼາຍຄັ້ງເກີນໄປ. ກະລຸນາລໍຖ້າ 1 ຊົ່ວໂມງ",
            );
          } else if (e.code == 'app-not-authorized') {
            emit(
              state.copyWith(
                authStatus: AuthStatus.failure,
                error: "ແອັບບໍ່ໄດ້ຮັບອະນຸຍາດ. ກະລຸນາຕິດຕໍ່ພັດທະນາ",
              ),
            );
            MessageHelper.showSnackBarMessage(
              isSuccess: false,
              message: "ແອັບບໍ່ໄດ້ຮັບອະນຸຍາດ. ກະລຸນາຕິດຕໍ່ພັດທະນາ",
            );
          } else {
            emit(
              state.copyWith(
                authStatus: AuthStatus.failure,
                error: "ກະລຸນາລອງໃໝ່ໃນພາຍຫຼັງ",
              ),
            );
          }
        },

        codeSent: (String verificationId, int? resendToken) {
          print("Code sent successfully");
          _verificationId = verificationId;
          _forceResendingToken = resendToken;

          emit(state.copyWith(authStatus: AuthStatus.success));
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      print("Error in sendOTPSafely: $e");
      emit(
        state.copyWith(
          authStatus: AuthStatus.failure,
          error: "ເກີດຂໍ້ຜິດພາດ. ກະລຸນາລອງໃໝ່ໃນພາຍຫຼັງ",
        ),
      );
    }
  }

  Future<void> verifyForgotOTP() async {
    try {
      if (_verificationId == null || _verificationId == "") {
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
            error: 'ລະຫັດ otp ບໍ່ຖືກຕ້ອງ',
          ),
        );
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: "ລະຫັດ otp ບໍ່ຖືກຕ້ອງ",
        );
      } else {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: pinController.text,
        );
        if (credential.smsCode == pinController.text) {
          signInWithForgotPhone(credential);
        } else {
          emit(
            state.copyWith(
              authStatus: AuthStatus.failure,
              error: 'ເບີນີ້ຍັງບໍ່ມີຢູ່ໃນລະບົບ',
            ),
          );
          MessageHelper.showSnackBarMessage(
            isSuccess: false,
            message: "ເບີນີ້ຍັງບໍ່ມີຢູ່ໃນລະບົບ",
          );
        }
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), authStatus: AuthStatus.failure));
    }
  }

  Future<void> verifyChangeOTP() async {
    try {
      if (_verificationId == null || _verificationId == "") {
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
            error: 'ລະຫັດ otp ບໍ່ຖືກຕ້ອງ',
          ),
        );
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: "ລະຫັດ otp ບໍ່ຖືກຕ້ອງ",
        );
      } else {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: pinController.text,
        );
        if (credential.smsCode == pinController.text) {
          signInWithChangePhone(credential);
        } else {
          emit(
            state.copyWith(
              authStatus: AuthStatus.failure,
              error: 'ເບີນີ້ມີຢູ່ໃນລະບົບແລ້ວ',
            ),
          );
          MessageHelper.showSnackBarMessage(
            isSuccess: false,
            message: "ເບີນີ້ມີຢູ່ໃນລະບົບແລ້ວ",
          );
        }
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), authStatus: AuthStatus.failure));
    }
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
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: "ລະຫັດ otp ບໍ່ຖືກຕ້ອງ",
        );
      } else {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: pinController.text,
        );
        if (credential.smsCode == pinController.text) {
          signInWithPhone(credential);
        } else {
          emit(
            state.copyWith(
              authStatus: AuthStatus.failure,
              error: 'ເບີນີ້ມີຢູ່ໃນລະບົບແລ້ວ',
            ),
          );
          MessageHelper.showSnackBarMessage(
            isSuccess: false,
            message: "ເບີນີ້ມີຢູ່ໃນລະບົບແລ້ວ",
          );
        }
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), authStatus: AuthStatus.failure));
    }
  }

  Future<void> signInWithChangePhone(PhoneAuthCredential credential) async {
    try {
      final userCredential = await auth.signInWithCredential(credential);
      await HiveDatabase.deleteGoogleToken();
      if (userCredential.user != null) {
        final user = await userCredential.user!.getIdToken();
        print("======>$user");
        ChangePhoneNumber(newPhoneNumber: phoneNumber.text, googleToken: user!);
      } else {
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
            error: 'ເບີນີ້ມີຢູ່ໃນລະບົບແລ້ວ',
          ),
        );
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: "ເບີນີ້ມີຢູ່ໃນລະບົບແລ້ວ",
        );
      }
    } on FirebaseException catch (ex) {
      emit(
        state.copyWith(authStatus: AuthStatus.failure, error: ex.toString()),
      );
    }
  }

  Future<void> signInWithPhone(PhoneAuthCredential credential) async {
    try {
      final userCredential = await auth.signInWithCredential(credential);
      await HiveDatabase.deleteGoogleToken();
      if (userCredential.user != null) {
        final user = await userCredential.user!.getIdToken();
        final token = await user;
        await HiveDatabase.saveGoogleToken(googleToken: token!);
        NavService.pushReplacementNamed(AppRoutes.confirm);
      } else {
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
            error: 'ເບີນີ້ມີຢູ່ໃນລະບົບແລ້ວ',
          ),
        );
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: "ເບີນີ້ມີຢູ່ໃນລະບົບແລ້ວ",
        );
      }
    } on FirebaseException catch (ex) {
      emit(
        state.copyWith(authStatus: AuthStatus.failure, error: ex.toString()),
      );
    }
  }

  Future<void> signInWithForgotPhone(PhoneAuthCredential credential) async {
    try {
      final userCredential = await auth.signInWithCredential(credential);
      await HiveDatabase.deleteGoogleToken();
      if (userCredential.user != null) {
        final user = await userCredential.user!.getIdToken();
        final token = await user;
        await HiveDatabase.saveGoogleToken(googleToken: token!);
        NavService.pushReplacementNamed(AppRoutes.reset_password);
      } else {
        emit(
          state.copyWith(
            authStatus: AuthStatus.failure,
            error: 'ເບີນີ້ຍັງບໍ່ມີຢູ່ໃນລະບົບ',
          ),
        );
        MessageHelper.showSnackBarMessage(
          isSuccess: false,
          message: "ເບີນີ້ຍັງບໍ່ມີຢູ່ໃນລະບົບ",
        );
      }
    } on FirebaseException catch (ex) {
      emit(
        state.copyWith(authStatus: AuthStatus.failure, error: ex.toString()),
      );
    }
  }

  //bankaccount part
  Future<void> fetchBankAccount() async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    final result = await authRepositories.getBankAccount();
    result.fold(
      (failure) => emit(
        state.copyWith(authStatus: AuthStatus.failure, error: failure.message),
      ),
      (account) => emit(
        state.copyWith(authStatus: AuthStatus.success, bankAccount: account),
      ),
    );
  }

  Future<void> addBankAccount({
    required String bankName,
    required String accountName,
    required String accountNo,
    required File image,
  }) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));

    final result = await authRepositories.addBankAccount(
      bankName: bankName,
      accountName: accountName,
      accountNo: accountNo,
      image: image,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(authStatus: AuthStatus.failure, error: failure.message),
      ),
      (success) async {
        if (success) {
          await fetchBankAccount();
        } else {
          emit(
            state.copyWith(
              authStatus: AuthStatus.failure,
              error: 'Failed to add bank account',
            ),
          );
        }
      },
    );
  }

  Future<void> updateBankAccount(BankAccount updated) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    final result = await authRepositories.updateBankAccount(updated);
    result.fold(
      (failure) => emit(
        state.copyWith(authStatus: AuthStatus.failure, error: failure.message),
      ),
      (account) async {
        emit(
          state.copyWith(authStatus: AuthStatus.success, bankAccount: account),
        );
        await fetchBankAccount();
      },
    );
  }
}
