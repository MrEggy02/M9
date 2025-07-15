// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m9/core/constants/app_constants.dart';
import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/data/network/api_path.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/order_state.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/data/repositories/order_repositories.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/domain/models/USER_SURVEY_DRIVER.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nav_service/nav_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';

class OrderCubit extends Cubit<OrderState> {
  final BuildContext context;
  OrderRepositories orderRepositories = OrderRepositories();
  OrderCubit({required this.context, required this.orderRepositories})
    : super(OrderState(orderStatus: OrderStatus.initial));

  bool mounted = true;
  bool isStart = false;
  int currenIndex = 0;
  int Index = 0;
  final name = TextEditingController();
  final someWhere = TextEditingController();
  GlobalKey<ScaffoldState>? scaffoldKey = GlobalKey<ScaffoldState>();

  // Position? currentPosition;
  PointAnnotationManager? annotationManager;
  MapboxMap? mapboxMap;
  List<dynamic> coordinates = [];
  // ---
  final Logger log = Logger();
  @override
  Future<void> close() {
    mounted = false;
    return super.close();
  }

  // ----- map ----
  final Set<Polyline> polyline = {};
  List<LatLng> route = [];
  // double dist = 0;
  late String displayTime;
  double value = 3.5;
  late int time;
  late int lastTime;
  //
  String? screenShot;
  bool isLoading = false;
  // -------
  GoogleMapController? controllerMap;
  LatLng currentPositionLatLng = LatLng(17.98147641662905, 102.61926245350267);
  LatLng lastPositionLatLng = LatLng(0.0, 0.0);
  Position? position;
  List<LatLng> polylinePoints = [];

  Future<void> OrderFindDriver({
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
    emit(state.copyWith(orderStatus: OrderStatus.loading));
    final result = await orderRepositories.OrderFindDriver(
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
    result.fold(
      (e) {
        emit(
          state.copyWith(orderStatus: OrderStatus.failure, error: e.toString()),
        );
      },
      (success) {
        emit(state.copyWith(orderStatus: OrderStatus.success));
      },
    );
  }

  Future<void> getUserSurverDriver() async {
    emit(state.copyWith(orderStatus: OrderStatus.loading));
    final result = await orderRepositories.getUserSurverDriver();
    result.fold(
      (error) {
        emit(
          state.copyWith(
            orderStatus: OrderStatus.failure,
            error: error.toString(),
          ),
        );
      },
      (success) {
        emit(state.copyWith(orderStatus: OrderStatus.success));
        NavService.pushReplacementNamed(AppRoutes.find_driver);
        socketConnect();
       
      },
    );
  }

  Future<void> socketConnect() async {
    try {
      final tokenMap = await HiveDatabase.getToken();
      final token = tokenMap['token'];
      // ເຊື່ອມຕໍ່ socket ພ້ອມ auth
      IO.Socket socket = IO.io(
        ApiPaths.baseURLSocket,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setAuth({'token': token})
            .build(),
      );

      emit(state.copyWith(orderStatus: OrderStatus.loading));

      if (!socket.connected) {
        log.d("Socket not connected. Trying to connect...");
        socket.connect();
      }

      socket.onConnect((_) {
        log.d("✅ Socket connected");

        // ເຟື່ອງຟັງຂໍ້ມູນຈາກ server
        socket.on('user-survey-driver', (data) {
          log.d("📨 USER_SURVEY_DRIVER: $data");
          final userSurveyDriverModel = userSurveyModelFromJson(data);
          emit(
            state.copyWith(
              userSurveyDriverModel: userSurveyDriverModel,
              orderStatus: OrderStatus.success,
            ),
          );
        });
      });

      socket.onDisconnect((_) => log.d("❌ Socket disconnected"));

      socket.onConnectError((err) => log.e("⚠️ Connect error: $err"));
      socket.onError((err) => log.e("❗ Socket error: $err"));
    } catch (e, stackTrace) {
      log.e(
        "🔥 Socket connection exception",
        time: DateTime.now(),
        error: e,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(orderStatus: OrderStatus.failure));
    }
  }

 
}
