// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'dart:convert';
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
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
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
  Set<Marker> _markers = {};
  BitmapDescriptor? _customMarker;
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
       // emit(state.copyWith(orderStatus: OrderStatus.success));
      },
    );
  }

  Future<void> loadCustomMarker({
    required UserSurveyDriverModel currentPositions,
  }) async {
    final icon = BitmapDescriptor.defaultMarker;
    _customMarker = icon;
    // ອັບເດດ marker ທັນທີ່ມີ icon
    _markers = {
      Marker(
        markerId: const MarkerId('position'),
        position: LatLng(currentPositions.lat!, currentPositions.lon!),
        icon: _customMarker!,
      ),
    };
  }

  Future<MqttClient> connectToEmqxBroker() async {
    final client = MqttServerClient.withPort(
      'h41770c0.ala.dedicated.aws.emqxcloud.com',
      'flutter_client_id_001',
      8883, // SSL port
    );

    // SSL setup
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;

    // Logging & Keep Alive
    client.logging(on: true);
    client.keepAlivePeriod = 20;

    // Callbacks
    client.onConnected = () => print('✅ Connected');
    client.onDisconnected = () => print('❌ Disconnected');
    client.onSubscribed = (String topic) {
      print('📌 Subscribed to: $topic');
    };

    // Connection message
    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client_id_001')
        .authenticateAs('user2', 'qwerty') // Add auth if needed
        .withWillTopic('willtopic') // Optional will topic
        .withWillMessage('Connection Closed Unexpectedly')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();

      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        print('🚀 MQTT connected to EMQX!');

        // Subscribe to topic
        const topic = 'USER/SURVEY/DRIVER/1d25faa3-efae-4cbf-95ba-2fd1dab99e69';
        client.subscribe(topic, MqttQos.atLeastOnce);
      } else {
        print('🛑 Failed to connect: ${client.connectionStatus}');
        client.disconnect();
      }
    } catch (e) {
      print('❗ Exception: $e');
      client.disconnect();
    }

    return client;
  }

  Future<void> listenMqtt() async {
    try {
      final client = await connectToEmqxBroker();
      await getUserSurverDriver();
      // Listen for messages
      client.updates?.listen((messages) {
        print('📥 update event triggered!');

        for (final message in messages) {
          final recMess = message.payload as MqttPublishMessage;
          final payload = MqttPublishPayload.bytesToStringAsString(
            recMess.payload.message,
          );
          // loadCustomMarker(
          //   currentPositions: UserSurveyDriverModel.fromJson(
          //     jsonDecode(payload),
          //   ),
          // );
          print('📨 Topic: ${message.topic}');
          // ເຊັກຢູ່ນີ້
          print('💬 Payload: $payload');
          emit(state.copyWith(orderStatus: OrderStatus.success));
          NavService.pushReplacementNamed(AppRoutes.find_driver);
          
        }
      });
    } catch (e) {}
  }

  Future<void> userReview() async {
    try {
      // user review driver ມັນຈະໄປມວນຜົນ
      //
    } catch (e) {}
  }

  Future<void> driverUpdateSuccess() async {
    try {
      // driver ກົດສຳເລັດ ແລະ ໃຫ້ຈ່າຍເງີນ 1 ຈ່າຍເງີນສົດ ໃຫ້ກົດເປັນຈ່າຍເງີນ
      // 2 ຈ່າຍເງິນໂອນໃຫ້ກົດເປັນຈ່າຍເງີນໂອນແລ້ວ generate qr code ໃຫ້ລູກຄ້າຈ່າຍເງີນ
    } catch (e) {}
  }

  Future<void> driverUpdateProgress() async {
    try {
      // driver ເມື່ອໄປເຖິງລູກຄ້າແລ້ວຕ້ອງກົດເລີ່ມຕົ້ນຂັບທັນທີ່
    } catch (e) {}
  }

  Future<void> userComfirmOrder() async {
    try {
      // ordriver ກົດຍອມຮັບ ApiPath chooseDriver ຫລັງຈາກນັ້ນສົ່ງdata
      // ກັບມາເພື່ອ ຕີ map ລະລົດຫາຜູ້ເອີ້ນ ແລະ mqtt ຕ້ອງທຳງານທັນທີ່ຕອນກົດ
    } catch (e) {}
  }

  //---- ຍັງບໍ່ໄດ້ເຮັດ API ກັບ check active ກໍ
  Future<void> userCancelOrder() async {
    try {
      // ordriver ກົດຍອມຮັບ ApiPath user canelOrder
    } catch (e) {}
  }

  Future<void> driveComfirmOrder() async {
    try {
      // ordriver ກົດຍອມຮັບ ApiPath chooseOrder
    } catch (e) {}
  }

  //2 ຮັບ socket ຈາກ customer ກົດຄົ້ນຫາລົດ
  Future<void> socketConnect() async {
    IO.Socket socket = await IO.io(ApiPaths.baseURLSocket, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    emit(state.copyWith(orderStatus: OrderStatus.loading));
    if (socket.connected == false) {
      print("socket stattus: ${socket.connected}");
      socket.connect();
    }

    //String? userid = await HiveDatabase.getUserId();

    socket.onConnect((data) {
      log.d("Connected");
      socket.on('order', (data) {
        emit(
          state.copyWith(useChooseCar: data, orderStatus: OrderStatus.success),
        );
      });
      socket.on('driver-list', (data) {
        // ສ້າງຕົວປ່ຽນເກັບໄວ້ໃຫ້ເປັນ list ເພາະ socket ສົ່ງແຕ່ obeject ມາກ່ອນດຽວບໍ່ໄດ້ສົງ array
        final list = [];
        list.add(data);
        emit(
          state.copyWith(driverList: list, orderStatus: OrderStatus.success),
        );
      });
    });

    socket.onDisconnect((con) {
      emit(state.copyWith(orderStatus: OrderStatus.failure));
      log.d("disconnect");
    });
  }

  Future<void> socketDisconnect() async {
    IO.Socket socket = await IO.io(ApiPaths.baseURLSocket, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    emit(state.copyWith(orderStatus: OrderStatus.failure));
    socket.disconnect();
  }
}
