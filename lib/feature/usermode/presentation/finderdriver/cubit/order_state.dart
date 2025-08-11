// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/domain/models/USER_SURVEY_DRIVER.dart';

enum OrderStatus { initial, loading, success, failure }

class OrderState extends Equatable {
  final String? error;
  final bool? isCheck;
  final OrderStatus? orderStatus;
  final dynamic useChooseCar;

  final List<dynamic>? driverList;
  final UserSurveyDriverModel? userSurveyDrivers;
  final List<UserSurveyDriverModel>? userSurveyDriverModel;
  final bool? isForms;
  final bool? isStart;
  final bool? loading;
  const OrderState({
    this.error,
    this.orderStatus,
    this.isCheck = false,
    this.isForms,
    this.isStart,
    this.loading,
    this.useChooseCar,
    this.userSurveyDrivers,
    this.driverList = const [],
    this.userSurveyDriverModel = const [],
  });
  OrderState copyWith({
    OrderStatus? orderStatus,
    String? formTime,
    bool isClearPolyline = false,
    bool? isCheck,
    String? error,
    int? currenIndex,
    int? indexActive,
    Position? position,
    bool? loading,
    dynamic useChooseCar,
    final List<dynamic>? driverList,
    UserSurveyDriverModel? userSurveyDrivers,
    List<UserSurveyDriverModel>? userSurveyDriverModel,
  }) {
    return OrderState(
      isCheck: isCheck ?? this.isCheck,
      error: error ?? this.error,
      isForms: isForms ?? this.isForms,
      isStart: isStart ?? this.isStart,
      loading: loading ?? this.loading,
      orderStatus: orderStatus ?? this.orderStatus,
      useChooseCar: useChooseCar ?? this.useChooseCar,
      driverList: driverList ?? this.driverList,
      userSurveyDriverModel:
          userSurveyDriverModel ?? this.userSurveyDriverModel,
      userSurveyDrivers: userSurveyDrivers ?? this.userSurveyDrivers,
    );
  }

  @override
  List<Object?> get props => [
    error,
    isCheck,
    orderStatus,
    isForms,
    isStart,
    loading,
    useChooseCar,
    driverList,
    userSurveyDriverModel,
    userSurveyDrivers,
  ];
}
