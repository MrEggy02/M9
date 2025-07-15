import 'package:dartz/dartz.dart';
import 'package:m9/core/data/network/api_status.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/data/service/order_service.dart';

class OrderRepositories {
  final orderService = OrderService();

  Future<Either<Failure, bool>> OrderFindDriver({
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
      final reuslt = await orderService.OrderFindDriver(
        serviceId: serviceId,
        carTypeId: carTypeId,
        pickupPlace: pickupPlace,
        pickupLocation: pickupLocation,
        distance: distance,
        destinationPlace: destinationPlace,
        destination: destination,
        price: price,
        estimateDurationMinute: estimateDurationMinute,
      );
      return right(reuslt);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> getUserSurverDriver() async {
    try {
      final reuslt = await orderService.getUserSurverDriver();
      return right(reuslt);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
