import 'dart:convert';

import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/data/network/api_path.dart';
import 'package:m9/core/data/network/network_service.dart';
import 'package:m9/core/data/response/api_response.dart';
import 'package:m9/feature/usermode/presentation/home/domain/models/banner.dart';
import 'package:m9/feature/usermode/presentation/home/domain/models/cart_type.dart';
import 'package:m9/feature/usermode/presentation/home/domain/models/service.dart';

class HomeService {
  final NetworkCall _networkCall = NetworkCall();
  Future<List<ServiceModel>?> getService() async {
    try {
     // final token = await HiveDatabase.getToken();
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        //'Authorization': 'Bearer ${token['token']}',
      };
      final ApiResponse response = await _networkCall.request(
        paths: ApiPaths.getservicePath,
        method: ApiPaths.getRequest,
        headers: headers,
      );
      if (response.status == true) {
        final service = serviceModelFromJson(jsonEncode(response.data['data']));
        return service;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<BannerModel>?> getBanner() async {
    try {
     // final token = await HiveDatabase.getToken();
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
       // 'Authorization': 'Bearer ${token['token']}',
      };
      final ApiResponse response = await _networkCall.request(
        paths: ApiPaths.getbannerPath,
        method: ApiPaths.getRequest,
        headers: headers,
      );
      print(response.data);
      if (response.status == true) {
        final result = bannerModelFromJson(jsonEncode(response.data['data']));
        return result;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<CartTypeModel>?> getCarType() async {
    try {
     // final token = await HiveDatabase.getToken();
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      //  'Authorization': 'Bearer ${token['token']}',
      };
      final ApiResponse response = await _networkCall.request(
        paths: ApiPaths.getCarTypePath,
        method: ApiPaths.getRequest,
        headers: headers,
      );
      if (response.status == true) {
        print(response.data);
        final result = cartTypeModelFromJson(jsonEncode(response.data['data']));
        return result;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
