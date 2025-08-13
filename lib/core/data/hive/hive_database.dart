import 'dart:convert';
import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:m9/feature/auth/domain/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase {
  static BoxCollection? box;

  static Future<BoxCollection?> hiveDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    box = await BoxCollection.open(
      'm9-driver', // Name of your database
      {'auth', 'driver', 'user'}, // Names of your boxes
      path: directory.path,
    );
    return box;
  }

  static Future<List<Map>> getHistory() async {
    final searchBox = await Hive.openBox('searchMap');
    return searchBox.values.cast<Map>().toList().toList();
  }

  static Future<bool> saveSearchMap({
    required String formatted_address,
    required String name,
  }) async {
    final searchBox = await Hive.openBox('searchMap');
    await searchBox.add({
      "name": name,
      "formatted_address": formatted_address,
      "timestamp": DateTime.now().toIso8601String(),
    });
    final data = searchBox.values.toList();
    print("====>${data}");
    return true;
  }

  static Future<bool> deleteSearchAll() async {
    try {
      final box = await Hive.openBox('searchMap');
      await box.clear();
      return true;
    } catch (e) {
      print("❌ Error: $e");
      return false;
    }
  }

  static Future<bool> deleteSearchAt({required int index}) async {
    try {
      final box = await Hive.openBox('searchMap');
      final keys = box.keys.toList();
      if (index >= 0 && index < keys.length) {
        final keyToDelete = keys[index];
        await box.delete(keyToDelete);
        print("✅ Deleted item at real Hive key: $keyToDelete");
        return true;
      } else {
        print("❌ Index $index is out of range.");
        return false;
      }
    } catch (e) {
      print("❌ Error: $e");
      return false;
    }
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

    return file;
  }

  static Future<dynamic> getGoogleToken() async {
    final userBox = await box!.openBox<Map>('auth');
    final googleToken = await userBox.getAll(['googleToken']);
    return googleToken[0]!['data'];
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
      'googleToken',
      
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

  static Future<bool> deleteGoogleToken() async {
    final userBox = await Hive.openBox<Map>('auth');
    await userBox.delete('googleToken');
    // await userBox.deleteAll(['googleToken']);

    return true;
  }

  static Future<bool> deleteUserId() async {
    final userBox = await box!.openBox<Map>('auth');
    await userBox.deleteAll(['user_id']);

    return true;
  }

  static Future<UserModel> getProfile() async {
    final userBox = await box!.openBox<Map>('auth');
    final data = await userBox.getAll(['profile']);
    final respone = jsonDecode(data[0]!['data']);
    print("====>${respone}");
    final user = UserModel.fromJson(respone);
     print("====>${user.username}");
    return user;
  }

  static Future<bool> saveLoginRemember({
    required String phoneNumber,
    required String password,
  }) async {
    final authBox = await box!.openBox<Map>('auth');
    await authBox.put("remember", {
      "phoneNumber": "20${phoneNumber}",
      "password": password,
    });
    return true;
  }

  static Future<dynamic> getLoginRemember() async {
    final userBox = await box!.openBox<Map>('auth');
    final googleToken = await userBox.getAll(['remember']);
    return googleToken[0];
  }

  static Future<bool> saveProfileImage({required File file}) async {
    final userBox = await box!.openBox<Map>('auth');
    await userBox.put("profile_image", {"data": file.toString()});
    return true;
  }

  static Future<bool> saveGoogleToken({required String googleToken}) async {
    final userBox = await box!.openBox<Map>('auth');
    await userBox.put("googleToken", {"data": googleToken});
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

    await userBox.put("tokens", {"token": token, "refreshToken": refresh});
    return true;
  }

  static Future<void> clearTime() async {
    final timeBox = await box!.openBox('time');
    await timeBox.clear();
  }

  static Future<void> setTime() async {
    final timeBox = await box!.openBox('time');
    await timeBox.put('data', DateTime.now());
  }
}
