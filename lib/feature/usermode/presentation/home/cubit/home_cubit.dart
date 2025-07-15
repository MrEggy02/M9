// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/data/response/messageHelper.dart';
import 'package:m9/feature/usermode/presentation/home/cubit/home_state.dart';
import 'package:m9/feature/usermode/presentation/home/data/repositories/home_repositories.dart';

class HomeCubit extends Cubit<HomeState> {
  final BuildContext context;
  final HomeRepositories homeRepositories;
  HomeCubit({required this.context, required this.homeRepositories})
    : super(HomeState(homeStatus: HomeStatus.initial));

  bool mounted = true;

  // ---

  @override
  Future<void> close() {
    mounted = false;
    return super.close();
  }

  List<dynamic> carType = [
    {
      "icon": "assets/images/usermode/car.png",
      "title": "ລົດໂດຍສານ",
      "price": "50.000",
      "amount": 4,
    },
    {
      "icon": "assets/images/usermode/ev.png",
      "title": "ລົດໄຟຟ້າ EV",
      "price": "51.000",
      "amount": 4,
    },
    {
      "icon": "assets/images/usermode/motobike.png",
      "title": "ລົດຈັກ",
      "price": "25.000",
      "amount": 1,
    },
  ];
  Future<void> getBanner() async {
    emit(state.copyWith(homeStatus: HomeStatus.loading));
    final result = await homeRepositories.getBanner();
    result.fold(
      (e) {
        emit(state.copyWith(homeStatus: HomeStatus.failure));
        MessageHelper.showTopSnackBar(
          context: context,
          message: e.toString(),
          isSuccess: false,
        );
      },
      (success) {
        emit(state.copyWith(
          homeStatus: HomeStatus.success, 
          banners: success));
      },
    );
  }

  Future<void> getService() async {
    emit(state.copyWith(homeStatus: HomeStatus.loading));
    final result = await homeRepositories.getService();
    result.fold(
      (e) {
        emit(state.copyWith(homeStatus: HomeStatus.failure));
        MessageHelper.showTopSnackBar(
          context: context,
          message: e.toString(),
          isSuccess: false,
        );
      },
      (success) {
        emit(state.copyWith(homeStatus: HomeStatus.success, services: success));
      },
    );
  }

  Future<void> getCarType() async {
    emit(state.copyWith(homeStatus: HomeStatus.loading));
    final result = await homeRepositories.getCarType();
    result.fold(
      (e) {
        emit(state.copyWith(homeStatus: HomeStatus.failure));
        MessageHelper.showTopSnackBar(
          context: context,
          message: e.toString(),
          isSuccess: false,
        );
      },
      (success) {
        emit(state.copyWith(homeStatus: HomeStatus.success, carTypes: success));
      },
    );
  }
}
