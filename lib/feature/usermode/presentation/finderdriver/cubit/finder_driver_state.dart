// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum FinderDriverStatus { initial, loading, success, failure }

class FinderDriverState extends Equatable {
  final String? error;
  final bool? isCheck;
  final FinderDriverStatus? finderDriverStatus;
  final List<LatLng>? polylinePoints;
  final Set<Polyline>? polylines;
  final Set<Circle>? circles;
  final BitmapDescriptor? markerIcon;
  final int? currenIndex;
  final int? indexActive;
  final int? index;
  final int? start;
  final bool? mapType;
  final bool? isForms;
  final bool? isStart;
  final bool? loading;
  const FinderDriverState({
    this.error,
    this.finderDriverStatus,
    this.currenIndex,
    this.indexActive,
    this.mapType,
    this.markerIcon,
    this.isCheck = false,
    this.isForms,
    this.isStart,
    this.index,
    this.loading,
    this.start,
    this.polylinePoints = const [],
    this.polylines = const {},
    this.circles = const {},
  });
  FinderDriverState copyWith({
    FinderDriverStatus? finderDriverStatus,
    String? formTime,
    bool isClearPolyline = false,
    BitmapDescriptor? markerIcon,
    List<LatLng>? polylinePoints,
    Set<Polyline>? polylines,
    Set<Circle>? circles,
    bool? isCheck,
    String? error,
    int? currenIndex,
    int? indexActive,
    Position? position,
    bool? mapType,
    bool? isForms,
    bool? isStart,
    int? start,
    LatLng? currentPositionLatLng,
    int? index,
    bool? loading,
  }) {
    return FinderDriverState(
      finderDriverStatus: finderDriverStatus ?? this.finderDriverStatus,
      isCheck: isCheck ?? this.isCheck,
      error: error ?? this.error,
      mapType: mapType ?? this.mapType,
      currenIndex: currenIndex ?? this.currenIndex,
      indexActive: indexActive ?? this.indexActive,
      index: index ?? this.index,
      isForms: isForms ?? this.isForms,
      isStart: isStart ?? this.isStart,
      start: start ?? this.start,
      loading: loading ?? this.loading,
      markerIcon: markerIcon ?? this.markerIcon,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      polylines: isClearPolyline ? null : polylines ?? this.polylines,
      circles: circles ?? this.circles,
    );
  }

  @override
  List<Object?> get props => [
    error,
    isCheck,
    finderDriverStatus,
    currenIndex,
    mapType,
    isForms,
    isStart,
    start,
    markerIcon,
    polylinePoints,
    polylines,
    circles,
    indexActive,
    index,
    loading,
  ];
}
