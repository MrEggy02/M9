// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:m9/feature/usermode/presentation/home/domain/models/banner.dart';
import 'package:m9/feature/usermode/presentation/home/domain/models/cart_type.dart';
import 'package:m9/feature/usermode/presentation/home/domain/models/service.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum DriverStatus { initial, loading, success, failure }

class DriverState extends Equatable {
  final String? error;
  final DriverStatus? driverStatus;
  final List<ServiceModel>? services;
  final List<BannerModel>? banners;
  final List<CartTypeModel>? carTypes;
  final WebViewController? controller;
  final bool? loading;
  const DriverState({
    this.error,
    this.driverStatus,
    this.loading,
    this.controller,
    this.services = const [],
    this.banners = const [],
    this.carTypes = const [],
  });
  DriverState copyWith({
    DriverStatus? driverStatus,
    String? error,
    bool? loading,
    final List<ServiceModel>? services,
    final List<BannerModel>? banners,
    final List<CartTypeModel>? carTypes,
    final WebViewController? controller,
  }) {
    return DriverState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      driverStatus: driverStatus ?? this.driverStatus,
      services: services ?? this.services,
      banners: banners ?? this.banners,
      carTypes: carTypes ?? this.carTypes,
      controller: controller ?? this.controller,
    );
  }

  @override
  List<Object?> get props => [
    error,
    loading,
    driverStatus,
    services,
    banners,
    carTypes,
    controller,
  ];
}
