import 'dart:convert';
import 'dart:io';
import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/data/network/api_path.dart';
import 'package:m9/core/data/network/network_service.dart';
import 'package:m9/core/data/response/api_response.dart';
import 'package:m9/feature/auth/domain/models/bank_account_model.dart';
import 'package:m9/feature/auth/domain/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class AuthService {
  final NetworkCall _networkCall = NetworkCall();

  Future<bool> updateUser({
    required String username,
    required String firstName,
    required String lastName,
    required String gender,
    required String dob,
    required String address,
    required String email,
  }) async {
    try {
      final token = await HiveDatabase.getToken();
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer ${token['token']}",
      };
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(ApiPaths.updateProfile),
      );
      request.headers.addAll(headers);
      // ເພີ່ມ field
      request.fields['username'] = username;
      request.fields['firstName'] = firstName;
      request.fields['lastName'] = lastName;
      request.fields['email'] = email;
      request.fields['gender'] = gender;
      request.fields['dob'] = dob;
      request.fields['address'] = address;
      var response = await request.send();
      if (response.statusCode == 200) {
        var body = await response.stream.bytesToString();
        print("✅ Success: $body");
        await HiveDatabase.saveProfile(profile: body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Error: ${e}");
      rethrow;
    }
  }

  Future<bool> updateProfile({required File avatar}) async {
    try {
      final token = await HiveDatabase.getToken();

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'multipart/form-data',
        'Authorization': 'Bearer ${token['token']}',
      };

      print("Uploading avatar from: ${avatar.path}");
      final url = Uri.parse(ApiPaths.updateProfile);
      final request = http.MultipartRequest('PUT', url);

      request.headers.addAll(headers);
      final image = await http.MultipartFile.fromPath(
        'avatar',
        File(avatar.path).path,
        contentType: MediaType('image', 'jpg'),
      );
      request.files.add(image);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Server Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (data['status'] == true) {
        print("✅ Success: ${data['data']}");
        await HiveDatabase.saveProfile(profile: jsonEncode(data['data']));
        return true;
      } else {
        print("❌ API Error: ${data['message'] ?? 'Unknown error'}");
        return false;
      }
    } catch (e) {
      print("❌ Exception: $e");
      rethrow;
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
      final token = await HiveDatabase.getToken();
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer ${token['token']}",
      };
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiPaths.addBankAccountPath),
      );
      // Add headers
      request.headers.addAll(headers);
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
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Error: ${e}");
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
      final token = await HiveDatabase.getToken();
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer ${token['token']}",
      };
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiPaths.addBankAccountPath),
      );
      // Add headers
      request.headers.addAll(headers);
      request.fields['id'] = accountId;
      request.fields['bankName'] = bankName;
      request.fields['accountName'] = accountName;
      request.fields['accountNo'] = accountNo;
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Error: ${e}");
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
      print("❌ Error: ${e}");
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
      print("❌ Error: ${e}");
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
      print("❌ Error: ${e}");
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
        print("====>${response.data}");
        await HiveDatabase.saveProfile(profile: jsonEncode(response.data));
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error: ${e}");
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
      print("❌ Error: ${e}");
      rethrow;
    }
  }

  Future<bool> ChangePhoneNumber({required String newPhoneNumber}) async {
    try {
      final googleToken = await HiveDatabase.getGoogleToken();
      final token = await HiveDatabase.getToken();
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer ${token['token']}",
      };
      final body = {
        "newPhoneNumber": '20' + newPhoneNumber,
        "googleToken": googleToken,
      };
      final response = await http.put(
        Uri.parse(ApiPaths.changePhoneNumberPath),
        body: body,
        headers: headers,
      );
      print("=====>${response.body}");
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await HiveDatabase.saveProfile(profile: jsonEncode(data['data']));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Error: ${e}");
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
        'Accept': 'application/json',
        'Authorization': "Bearer ${token['token']}",
      };
      final body = {
        "oldPassword": oldPassword,
        "password": password,
        "confirmPassword": confirmPassword,
      };
      final response = await http.put(
        Uri.parse(ApiPaths.changePasswordPath),
        body: body,
        headers: headers,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Error: ${e}");
      rethrow;
    }
  }

  Future<List<BankAccount>?> getBankAccounts() async {
    try {
      final token = await HiveDatabase.getToken();
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer ${token['token']}",
      };
      final response = await http.get(
        Uri.parse(ApiPaths.getBankAccountsPath),
        headers: headers,
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final banks = bankModelFromJson(jsonEncode(data['data']));
        return banks;
      }
      return null;
    } catch (e) {
      print('❌ Error in getBankAccounts: $e');
      return null;
    }
  }

  Future<bool> validateAuth() async {
    try {
      var token = await HiveDatabase.getToken();

      if (token['refreshToken'] == null || token['refreshToken'] == '') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
