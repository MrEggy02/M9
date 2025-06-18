import 'package:dartz/dartz.dart';
import 'package:m9/core/data/network/api_status.dart';
import 'package:m9/feature/usermode/presentation/home/data/services/home_service.dart';
import 'package:m9/feature/usermode/presentation/home/domain/models/banner.dart';
import 'package:m9/feature/usermode/presentation/home/domain/models/cart_type.dart';
import 'package:m9/feature/usermode/presentation/home/domain/models/service.dart';

class HomeRepositories {
  HomeService homeService = HomeService();

  Future<Either<Failure, List<BannerModel>?>> getBanner() async {
    try {
      final reuslt = await homeService.getBanner();
      return right(reuslt!);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<ServiceModel>?>> getService() async {
    try {
      final reuslt = await homeService.getService();
      return right(reuslt!);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<CartTypeModel>?>> getCarType() async {
    try {
      final reuslt = await homeService.getCarType();
      return right(reuslt!);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
