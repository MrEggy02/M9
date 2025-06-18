import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/data/network/api_path.dart';
import 'package:m9/core/data/network/network_service.dart';
import 'package:m9/core/data/response/api_response.dart';


class OrderService {
  final NetworkCall _networkCall = NetworkCall();
  Future<bool> OrderFindDriver({
    required String serviceId,
    required String carTypeId,
    required String pickupPlace,
    required dynamic pickupLocation,
    required int distance,
    required String destinationPlace,
    required dynamic destination,
    required int price,
    required int estimateDurationMinute,
  }) async {
    try {
      final token = await HiveDatabase.getToken();
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token['token']}',
      };
      final body = {
        "serviceId": serviceId,
        "carTypeId": carTypeId,
        "pickupPlace": pickupPlace,
        "pickupLocation": pickupLocation,
        "distance": distance,
        "destinationPlace": destinationPlace,
        "destination": destination,
        "price": price,
        "estimateDurationMinute": estimateDurationMinute,
      };
      final ApiResponse response = await _networkCall.request(
        paths: ApiPaths.createOrderCustomer,
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
}
