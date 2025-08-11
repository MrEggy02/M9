import 'dart:convert';
import 'dart:io';
import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/data/network/api_path.dart';
import 'package:m9/core/data/network/network_service.dart';
import 'package:m9/core/data/response/api_response.dart';
import 'package:m9/feature/auth/domain/models/bank_account_model.dart';
import 'package:m9/feature/auth/domain/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final NetworkCall _networkCall = NetworkCall();

  Future<bool> SignInWithGoogle({
    required String name,
    required String email,
    required String accessToken,
    required String googleId,
  }) async {
    try {
      Map<String, String> headers = {'Accept': 'application/json'};
      var body = {
        "name": name,
        "googleToken": accessToken,
        "email": email,
        "googleId": googleId,
      };

      final response = await http.post(
        Uri.parse(ApiPaths.google),
        body: body,
        headers: headers,
      );

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await HiveDatabase.deleteToken();
        await HiveDatabase.saveToken(
          token: data['data']['token'],
          refresh: data['data']['refresh_token'],
        );
        await HiveDatabase.saveProfile(profile: jsonEncode(data['data']));
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

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

  Future<bool> Forgot({required String phoneNumber}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final body = {"phoneNumber": phoneNumber};
      final response = await _networkCall.request(
        paths: ApiPaths.forgotPasswordPath,
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

  Future<bool> ResetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final googleToken = await HiveDatabase.getGoogleToken();

      Map<String, String> headers = {'Accept': 'application/json'};
      final body = {
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
        "googleToken": googleToken,
      };
      final response = await http.put(
        Uri.parse(ApiPaths.resetPasswordPath),
        body: body,
        headers: headers,
      );
      
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> AvailablePhoneNumber({required String phoneNumber}) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final body = {"phoneNumber": phoneNumber};
      final ApiResponse response = await _networkCall.request(
        paths: ApiPaths.availablePhoneNumber,
        method: ApiPaths.postRequest,
        body: body,
        headers: headers,
      );
      print("======>${response.data}");
      if (response.status == true) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
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
        await HiveDatabase.deleteToken();
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
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    try {
      final googleToken = await HiveDatabase.getGoogleToken();

      Map<String, String> headers = {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final body = {
        "username": username,
        "password": password,
        "confirmPassword": confirmPassword,
        "phoneNumber": "20${phoneNumber}",
        "googleToken": googleToken,
      };

      final response = await http.post(
        Uri.parse(ApiPaths.registerPath),
        body: body,
        headers: headers,
      );
      var data = jsonDecode(response.body);
      if (data['status'] == true) {
        await HiveDatabase.deleteToken();
        await HiveDatabase.saveToken(
          token: data['data']['token'],
          refresh: data['data']['refresh_token'],
        );
        await HiveDatabase.saveProfile(profile: jsonEncode(data['data']));
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> editProfile({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String gender,
    required String dob,
    String? address,
  }) async {
    final body = {
      "firstName": firstName.trim(),
      "lastName": lastName.trim(),
      "gender": gender,
      "dob": dob,
    };

    return true;
  }

  Future<bool> ChangePassword({
    required String oldPassword,
    required String password,
    required String confirmPassword,
  }) async {
    return true;
  }

  Future<List<BankAccount>?> getBankAccounts() async {
    try {
      return null;
    } catch (e) {
      print('❌ Error in getBankAccounts: $e');
    }
  }

  // Fixed AuthService addBankAccount method
  Future<bool> addBankAccount({
    required String bankName,
    required String accountName,
    required String accountNo,
    required File image,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiPaths.addBankAccountPath),
      );

      // Add headers
      //request.headers.addAll(_multipartHeaders);

      // Add form fields
      request.fields['bankName'] = bankName;
      request.fields['accountName'] = accountName;
      request.fields['accountNo'] = accountNo;

      // Add image file
      var multipartFile = await http.MultipartFile.fromPath(
        'image',
        image.path,
      );
      request.files.add(multipartFile);

      // Send request
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editBankAccount({
    required String accountId,
    required String bankName,
    required String accountName,
    required String accountNo,
    String? image,
  }) async {
    try {
      http.Response response;

      // Prepare the base request data
      final requestData = {
        "id": accountId, // Include the ID in the request body
        "bankName": bankName.trim(),
        "accountName": accountName.trim(),
        "accountNo": accountNo.trim(),
      };
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteBankAccount({required String accountId}) async {
    try {
      final uri = Uri.parse('${ApiPaths.editBankAccountPath}/$accountId');

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkConnectivity() async {
    try {
      final response = await http
          .get(Uri.parse(ApiPaths.getProfilePath))
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200 || response.statusCode == 401;
    } catch (e) {
      return false;
    }
  }
}
