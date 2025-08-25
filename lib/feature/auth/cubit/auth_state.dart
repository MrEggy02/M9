import 'package:equatable/equatable.dart';
import 'package:m9/feature/auth/domain/models/bank_account_model.dart';
import 'package:m9/feature/auth/domain/models/user_model.dart';

enum AuthStatus { initial, loading, googleLoading, success, failure }

class AuthState extends Equatable {
  final String? error;
  final AuthStatus? authStatus;
  final UserModel? userModel;
  final bool? isCheck;
  final BankAccount? bankAccount;
  final bool isUpdate;

  const AuthState({
    this.error,
    this.authStatus,
    this.userModel,
    this.isCheck,
    this.bankAccount,
    this.isUpdate = false,
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    String? error,
    UserModel? userModel,
    bool? isCheck,
    BankAccount? bankAccount,
    bool? isUpdate,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      userModel: userModel ?? this.userModel,
      error: error ?? this.error,
      isCheck: isCheck ?? this.isCheck,
      bankAccount: bankAccount ?? this.bankAccount,
      isUpdate: isUpdate ?? this.isUpdate,
    );
  }

  @override
  List<Object?> get props => [
    error,
    authStatus,
    isCheck,
    userModel,
    bankAccount,
    isUpdate,
  ];
}
