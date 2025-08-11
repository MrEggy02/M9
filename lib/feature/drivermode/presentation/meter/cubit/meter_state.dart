// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MeterStatus { initial, loading, success, failure }

class MeterState extends Equatable {
  final String? error;
  final bool? isCheck;
  final MeterStatus? meterStatus;
  final LatLng? currentPositionLatLng;
  final String? formTime;
  final List<LatLng>? routeCoordinates;
  final Set<Polyline>? polylines;
  final Set<Circle>? circles;
  final BitmapDescriptor? markerIcon;
  final int? currenIndex;
  final Position? position;
  final bool? mapType;
  final bool? isMeter;
  final bool? isStart;

  MeterState({
    this.error,
    this.meterStatus,
    this.currenIndex,
    this.mapType,
    this.position,
    this.markerIcon,
    this.isCheck = false,
    this.isMeter,
    this.isStart,
    this.currentPositionLatLng,
    this.formTime,
    this.routeCoordinates = const [],
    this.polylines = const {},
    this.circles = const {},
  });
  MeterState copyWith({
    MeterStatus? meterStatus,
    String? formTime,
    bool isClearPolyline = false,
    BitmapDescriptor? markerIcon,
    List<LatLng>? routeCoordinates,
    Set<Polyline>? polylines,
    Set<Circle>? circles,
    bool? isCheck,
    String? error,
    int? currenIndex,
    Position? position,
    bool? mapType,
    bool? isMeter,
    bool? isStart,
    LatLng? currentPositionLatLng,
  }) {
    return MeterState(
      meterStatus: meterStatus ?? this.meterStatus,
      formTime: formTime ?? this.formTime,
      isCheck: isCheck ?? this.isCheck,
      position: position ?? this.position,
      error: error ?? this.error,
      mapType: mapType ?? this.mapType,
      currenIndex: currenIndex ?? this.currenIndex,
      isMeter: isMeter ?? this.isMeter,
      isStart: isStart ?? this.isStart,
      currentPositionLatLng:
          currentPositionLatLng ?? this.currentPositionLatLng,
      routeCoordinates: routeCoordinates ?? this.routeCoordinates,
      polylines: isClearPolyline ? null : polylines ?? this.polylines,
      circles: circles ?? this.circles,
    );
  }

  @override
  List<Object?> get props => [
    error,
    isCheck,
    meterStatus,
    currenIndex,
    mapType,
    isMeter,
    isStart,
    position,
    markerIcon,
    currentPositionLatLng,
    formTime,
    routeCoordinates,
    polylines,
    circles,
  ];
}
