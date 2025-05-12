
import 'package:flutter/material.dart';
import 'package:m9/feature/presentation/pages/home/data/repositories/banner_repository.dart';
import 'package:m9/feature/presentation/pages/home/data/repositories/service_repository.dart';
import 'package:m9/feature/presentation/pages/home/data/repositories/user_repository.dart';
import 'package:m9/feature/presentation/pages/home/domain/models/banner.dart';
import 'package:m9/feature/presentation/pages/home/domain/models/user.dart';
import 'package:m9/feature/presentation/pages/home/domain/models/service.dart';

// ເຫດການທີ່ສາມາດເກີດຂຶ້ນໃນໜ້າຫຼັກ
abstract class HomeEvent {}

class LoadHomeDataEvent extends HomeEvent {}
class OpenProfileEvent extends HomeEvent {}
class SelectServiceEvent extends HomeEvent {
  final Service service;
  SelectServiceEvent(this.service);
}

// ສະຖານະຂອງໜ້າຫຼັກ
class HomeState {
  final bool isLoading;
  final User? user;
  final List<BannerModel> banners;
  final List<Service> services;
  final String? error;

  HomeState({
    this.isLoading = false,
    this.user,
    this.banners = const [],
    this.services = const [],
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    User? user,
    List<BannerModel>? banners,
    List<Service>? services,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      banners: banners ?? this.banners,
      services: services ?? this.services,
      error: error ?? this.error,
    );
  }
}

// BLoC ສຳລັບຈັດການສະຖານະແລະເຫດການຂອງໜ້າຫຼັກ
class HomeBloc extends ChangeNotifier {
  final UserRepository _userRepository;
  final BannerRepository _bannerRepository;
  final ServiceRepository _serviceRepository;
  
  HomeState _state = HomeState(isLoading: true);
  HomeState get state => _state;
  
  HomeBloc({
    required UserRepository userRepository,
    required BannerRepository bannerRepository,
    required ServiceRepository serviceRepository,
  }) : _userRepository = userRepository,
       _bannerRepository = bannerRepository,
       _serviceRepository = serviceRepository {
    // ໂຫຼດຂໍ້ມູນເມື່ອສ້າງ BLoC
    loadHomeData();
  }
  
  // ໂຫຼດຂໍ້ມູນສຳລັບໜ້າຫຼັກທັງໝົດ
  Future<void> loadHomeData() async {
    _state = _state.copyWith(isLoading: true, error: null);
    notifyListeners();
    
    try {
      final user = await _userRepository.getCurrentUser();
      final banners = await _bannerRepository.getBanners();
      final services = await _serviceRepository.getServices();
      
      _state = _state.copyWith(
        isLoading: false,
        user: user,
        banners: banners,
        services: services,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນໄດ້: ${e.toString()}',
      );
    }
    
    notifyListeners();
  }
  
  // ເປີດໜ້າຂໍ້ມູນສ່ວນຕົວ
  void openProfile() {
    // ໃນອະນາຄົດຈະເພີ່ມການນຳທາງໄປໜ້າໂປຣໄຟລ໌
    print('ເປີດຂໍ້ມູນສ່ວນຕົວຂອງ: ${_state.user?.name}');
  }
  
  // ເລືອກບໍລິການ
  void selectService(Service service) {
    // ໃນອະນາຄົດຈະເພີ່ມການນຳທາງໄປໜ້າບໍລິການທີ່ເລືອກ
    print('ເລືອກບໍລິການ: ${service.name}');
  }
}