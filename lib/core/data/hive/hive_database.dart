import 'dart:convert';
import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase {
  static BoxCollection? box;

  Future<BoxCollection?> hiveDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    box = await BoxCollection.open(
      'm9-driver', // Name of your database
      {'auth', 'driver', 'user'}, // Names of your boxes
      path: directory.path,
    );
    return box;
  }

  static Future<dynamic> getToken() async {
    final userBox = await box!.openBox<Map>('auth');
    final data = await userBox.getAll(['tokens']);
    return data[0];
  }

  static Future<dynamic> getInitSplash() async {
    final userBox = await box!.openBox<Map>('auth');
    final data = await userBox.getAll(['init']);
    return data[0];
  }

  static Future<bool> saveInitSplash({required bool init}) async {
    final userBox = await box!.openBox<Map>('auth');
    await userBox.put("init", {"data": init});
    return true;
  }

  static Future<dynamic> getProfileImage() async {
    final userBox = await box!.openBox<Map>('auth');
    final data = await userBox.get("profile_image");
    final file = jsonDecode(data!['data']);
    // print(file);
    return file;
  }

  static Future<dynamic> getUserId() async {
    final userBox = await box!.openBox<Map>('auth');
    final data = await userBox.get("user_id");
    final userId = jsonDecode(data!['data']);

    return userId;
  }

  static Future<bool> deleteAll() async {
    final userBox = await box!.openBox<Map>('auth');
    await userBox.deleteAll([
      'register',
      'address',
      'profile',
      'tokens',
      'user_id',
    ]);

    return true;
  }

  static Future<bool> deleteProfile() async {
    final userBox = await box!.openBox<Map>('auth');
    await userBox.deleteAll(['profile']);

    return true;
  }

  static Future<bool> deleteToken() async {
    final userBox = await box!.openBox<Map>('auth');
    await userBox.deleteAll(['tokens']);

    return true;
  }

  static Future<bool> deleteUserId() async {
    final userBox = await box!.openBox<Map>('auth');
    await userBox.deleteAll(['user_id']);

    return true;
  }

  static Future<dynamic> getProfile() async {
    final userBox = await box!.openBox<Map>('auth');
    final data = await userBox.getAll(['profile']);
    final respone = jsonDecode(data[0]!['data']);

    return respone;
  }

  static Future<bool> saveProfileImage({required File file}) async {
    final userBox = await box!.openBox<Map>('auth');
    await userBox.put("profile_image", {"data": file.toString()});
    return true;
  }

  static Future<bool> saveUserId({required String user_id}) async {
    final userBox = await box!.openBox<Map>('auth');
    await userBox.put("user_id", {"data": user_id});
    return true;
  }

  static Future<bool> saveProfile({required String profile}) async {
    final userBox = await box!.openBox<Map>('auth');
    await userBox.put("profile", {"data": profile});
    return true;
  }

  static Future<bool> saveToken({
    required String token,
    required String refresh,
  }) async {
    final userBox = await box!.openBox<Map>('auth');

    await userBox.put("tokens", {
      "accessToken": token,
      "refreshToken": refresh,
    });
    return true;
  }
}
