// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:m9/feature/usermode/presentation/home/domain/models/banner.dart';
import 'package:m9/feature/usermode/presentation/home/domain/models/cart_type.dart';
import 'package:m9/feature/usermode/presentation/home/domain/models/service.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final String? error;
  final HomeStatus? homeStatus;
  final List<ServiceModel>? services;
  final List<BannerModel>? banners;
  final List<CartTypeModel>? carTypes;
  final bool? loading;
  const HomeState({
    this.error,
    this.homeStatus,
    this.loading,
    this.services = const [],
    this.banners = const [],
    this.carTypes = const [],
  });
  HomeState copyWith({
    HomeStatus? homeStatus,
    String? error,
    bool? loading,
    final List<ServiceModel>? services,
    final List<BannerModel>? banners,
    final List<CartTypeModel>? carTypes,
  }) {
    return HomeState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      homeStatus: homeStatus ?? this.homeStatus,
      services: services ?? this.services,
      banners: banners ?? this.banners,
      carTypes: carTypes ?? this.carTypes,
    );
  }

  @override
  List<Object?> get props => [
    error,
    loading,
    homeStatus,
    services,
    banners,
    carTypes,
  ];
}
