// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m9/feature/auth/domain/models/user_model.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final String? error;

  final AuthStatus? authStatus;
  final UserModel? userModel;
  const AuthState({this.error, this.authStatus, this.userModel});
  AuthState copyWith({
    AuthStatus? authStatus,
    String? error,
    UserModel? userModel,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      userModel: userModel ?? this.userModel,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [error, authStatus, userModel];
}
