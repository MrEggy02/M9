import 'dart:convert';
import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/data/network/api_path.dart';
import 'package:m9/core/data/network/network_service.dart';
import 'package:m9/core/data/response/api_response.dart';
import 'package:m9/feature/auth/domain/models/user_model.dart';

class AuthService {
  final NetworkCall _networkCall = NetworkCall();

  Future<UserModel?> getProfile() async {
    try {
      final result = await HiveDatabase.getProfile();
      if (result.id == null) {
        return null;
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<bool> Login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final body = {"phoneNumber": phoneNumber, "password": password};
      final ApiResponse response = await _networkCall.request(
        paths: ApiPaths.loginPath,
        method: ApiPaths.postRequest,
        body: body,
        headers: headers,
      );

      if (response.status == true) {
        print("=====>${response.data}");
        await HiveDatabase.saveToken(
          token: response.data['token'],
          refresh: response.data['refresh_token'],
        );
        await HiveDatabase.saveProfile(profile: jsonEncode(response.data));
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> Register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final body = {
        "username": username,
        "password": password,
        "confirmPassword": confirmPassword,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
      };
      final ApiResponse response = await _networkCall.request(
        paths: ApiPaths.registerPath,
        method: ApiPaths.postRequest,
        body: body,
        headers: headers,
      );

      if (response.status == true) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> ChangePassword({
    required String oldPassword,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final token = await HiveDatabase.getToken();
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer ${token['token']}",
      };
      final body = {
        "oldPassword": oldPassword,
        "password": password,
        "confirmPassword": confirmPassword,
      };
      final ApiResponse response = await _networkCall.request(
        paths: ApiPaths.changePasswordPath,
        method: ApiPaths.putRequest,
        body: body,
        headers: headers,
      );

      if (response.status == true) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
