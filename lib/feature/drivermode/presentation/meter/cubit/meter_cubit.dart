// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:logger/logger.dart';
import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/feature/drivermode/presentation/meter/cubit/meter_state.dart';
import 'package:m9/feature/drivermode/presentation/meter/widget/mytaskhandler.dart';
import 'package:m9/feature/drivermode/presentation/meter/widget/sharedpfr.dart';
import 'package:nav_service/nav_service.dart';

import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class MeterCubit extends Cubit<MeterState> {
  final BuildContext context;

  MeterCubit({required this.context})
    : super(MeterState(meterStatus: MeterStatus.initial));

  bool mounted = true;
  bool isStart = false;
  int currenIndex = 0;
  final name = TextEditingController();
  final someWhere = TextEditingController();

  Position? currentPosition;
  List<String> category = [];

  @override
  Future<void> close() {
    mounted = false;
    return super.close();
  }

  // ----- map ----
  final Set<Polyline> polyline = {};
  List<LatLng> route = [];
  double dist = 0;
  late String displayTime;
  late int time;
  late int lastTime;
  double speed = 0;
  double avgSpeed = 0;
  int speedCounter = 0;
  late bool loadingStatus;
  late double appendDist;
  final StopWatchTimer stopWatchTimer = StopWatchTimer();
  var mapStyle;
  bool isMapType = false;
  // late StreamSubscription<Position> positionStream;
  // final Set<Marker> markers = Set();
  //
  String? screenShot;
  // -------
  GoogleMapController? controllerMap;
  LatLng currentPositionLatLng = LatLng(0.0, 0.0);
  List<LatLng> routeCoordinates = [];
  Set<Polyline> polylines = {};
 
  Set<Circle> circles = {}; // 🔥 ใช้ Set<Circle> แทน Marker

  // 🔥 ตัวจับเวลา
  //Stopwatch stopwatch = Stopwatch()..start();

  Timer? timer;
  // String formattedTime = "00:00:00";
  // -------

  void onTap(isStart) {
    emit(state.copyWith(isStart: isStart));
  }

  // Future<void> checkOnWorking() async {
  //   final rs = await HiveDatabase.getStartTracking();
  //   if (rs != null && rs.isNotEmpty) {
  //     List<Position> polys = (await Sharedpfr.getPoly())
  //         .map((e) => (e['position'] as Position))
  //         .toList();
  //     if (polys.isNotEmpty) {
  //       Logger().d(polys);
  //       final time = await HiveDatabase.getTime();
  //       if (time != null) {
  //         final elapsed = DateTime.now().difference(time);
  //         stopWatchTimer.setPresetTime(mSec: elapsed.inMilliseconds);
  //       }
  //       polyline.addAll(polys
  //           .map((e) => Polyline(
  //               polylineId: PolylineId(e.toString()),
  //               visible: true,
  //               points:
  //                   polys.map((e) => LatLng(e.latitude, e.longitude)).toList(),
  //               width: 6,
  //               startCap: Cap.roundCap,
  //               endCap: Cap.roundCap,
  //               color: Colors.blue))
  //           .toSet());
  //       Logger().d(polyline);
  //       emit(state.copyWith(
  //         isStart: true,
  //         position: polys.first,
  //         polylines: polyline,
  //       ));
  //       await startMap(isContinue: true);
  //       _resumeTimer();
  //     }
  //   }
  // }

  Future<void> startMap({bool isContinue = false}) async {
    //await Future.delayed(Duration(seconds: 2));
    route.clear();
    // polyline.clear();
    //dist = 0;
    time = 0;
    lastTime = 0;
    speed = 0;
    avgSpeed = 0;
    speedCounter = 0;
    appendDist = 0;

    // stopWatchTimer.onResetTimer();
    // stopWatchTimer.clearPresetTime();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentPosition(isContinue: isContinue);
    });
    // stopWatchTimer.onStartTimer();
    //  emit(state.copyWith(meterStatus: MetersStatus.success));
    // stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  // Future<void> getCurrentPosition() async {
  //   //emit(state.copyWith(meterStatus: MetersStatus.loading));
  //   late LocationSettings locationSettings;
  //   locationSettings = const LocationSettings(
  //       accuracy: LocationAccuracy.high, distanceFilter: 5);
  //   Geolocator.getPositionStream(locationSettings: locationSettings)
  //       .listen((position) {
  //     currentPosition = position;
  //     emit(state.copyWith(position: currentPosition));
  //   });

  //   emit(state.copyWith(position: currentPosition));

  //   positionStream =
  //       Geolocator.getPositionStream(locationSettings: locationSettings)
  //           .listen((Position? position) async {
  //     currentPosition = position;
  //     emit(state.copyWith(position: currentPosition));
  //     if (route.isNotEmpty) {
  //       appendDist = Geolocator.distanceBetween(route.last.latitude,
  //           route.last.longitude, position!.latitude, position.longitude);
  //       dist = dist + appendDist;
  //       int timeDuration = (time - lastTime);

  //       if (lastTime != null && timeDuration != 0) {
  //         speed = (appendDist / (timeDuration / 100)) * 3.6;
  //         if (speed != 0) {
  //           avgSpeed = avgSpeed + speed;
  //           speedCounter++;
  //         }
  //       }
  //     }
  //     lastTime = time;

  //     if (route.isNotEmpty) {
  //       if (route.last != LatLng(position!.latitude, position.longitude)) {
  //         route.add(LatLng(position.latitude, position.longitude));

  //         //  _updatePolyline(position);
  //         polyline.add(Polyline(
  //             polylineId: PolylineId(position.toString()),
  //             visible: true,
  //             points: route,
  //             width: 6,
  //             startCap: Cap.roundCap,
  //             endCap: Cap.roundCap,
  //             color: Colors.blue));
  //       }
  //     } else {
  //       route.add(LatLng(position!.latitude, position.longitude));
  //     }
  //   });
  // }

  Future<void> getCurrentPosition({bool isContinue = false}) async {
    final newPosition = await Geolocator.getCurrentPosition();
    List<Position> polys =
        (await Sharedpfr.getPoly())
            .map((e) => (e['position'] as Position))
            .toList();
    if (!isContinue) {
      emit(
        state.copyWith(position: newPosition, meterStatus: MeterStatus.success),
      );
      await HiveDatabase.setTime();
      await Sharedpfr.savePoly(polys);
    } else {
      await Sharedpfr.savePoly(polys);
      emit(state.copyWith(meterStatus: MeterStatus.success));
    }
    await MyTaskHandler.startService();
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (_) async {
      await checkForUpdate();
    });
  }

  Future<void> checkForUpdate() async {
    List<Position> polys =
        (await Sharedpfr.getPoly())
            .map((e) => (e['position'] as Position))
            .toList();
    try {
      polyline.add(
        Polyline(
          polylineId: PolylineId((polys.last.toString())),
          visible: true,
          points: polys.map((e) => LatLng(e.latitude, e.longitude)).toList(),
          width: 6,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          color: Colors.blue,
        ),
      );
      final Set<Polyline> updatet = {...polyline};
      try {
        final _currenPosition = LatLng(
          polys.last.latitude,
          polys.last.longitude,
        );
        currentPositionLatLng = _currenPosition;
        await controllerMap?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(polys.last.latitude, polys.last.longitude),
          ),
        );
      } catch (e) {
        print("====> $e");
      }

      emit(
        state.copyWith(
          // position: polys.last,
          meterStatus: MeterStatus.success,
          polylines: updatet,
          error: polyline.length.toString(),
        ),
      );
    } catch (e) {}
  }

  Future<void> _startTracking() async {
    Geolocator.getPositionStream().listen((Position position) {
      LatLng newPosition = LatLng(position.latitude, position.longitude);

      currentPositionLatLng = newPosition;
      routeCoordinates.add(newPosition);
      _updatePolyline();
      emit(
        state.copyWith(
          meterStatus: MeterStatus.success,
          currentPositionLatLng: currentPositionLatLng,
          routeCoordinates: routeCoordinates,
        ),
      );

      controllerMap?.animateCamera(
        CameraUpdate.newLatLng(currentPositionLatLng),
      );
    });
  }

  void _updatePolyline() {
    polylines.clear();
    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: routeCoordinates,
        color: Colors.blue,
        width: 5,
      ),
    );
    emit(
      state.copyWith(meterStatus: MeterStatus.success, polylines: polylines),
    );
  }

  // 🔥 เริ่มอัปเดตเวลาทุกวินาที
  void _startTimer() {
    time = 0;
    lastTime = 0;
    stopWatchTimer.onResetTimer();
    stopWatchTimer.clearPresetTime();
    stopWatchTimer.onStartTimer();
  }

  void _resumeTimer() {
    stopWatchTimer.onStartTimer();
  }

  Future<void> onTapMapType(bool _isMapType) async {
    isMapType = _isMapType;
    emit(state.copyWith(mapType: isMapType));
  }

  setIsStart() {
    emit(state.copyWith(isStart: false));
  }
}
