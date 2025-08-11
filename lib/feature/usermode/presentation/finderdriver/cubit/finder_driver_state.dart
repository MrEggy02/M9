// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/domain/models/polyline_model.dart';

enum FinderDriverStatus { initial, loading, success, failure }

class FinderDriverState extends Equatable {
  final String? error;
  final bool? isCheck;
  final bool? isSearch;
  final FinderDriverStatus? finderDriverStatus;
  final PolylineModel? polylineDataModel;
  final LatLng? currentCenter;
  final dynamic polyline;
  final List<dynamic>? historySearch;
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
    this.currentCenter,
    this.finderDriverStatus,
    this.currenIndex,
    this.polyline,
    this.indexActive,
    this.historySearch = const [],
    this.mapType,
    this.markerIcon,
    this.isSearch = false,
    this.isCheck = false,
    this.isForms,
    this.isStart,
    this.index,
    this.loading,
    this.start,
    this.polylineDataModel,
    this.polylinePoints = const [],
    this.polylines = const {},
    this.circles = const {},
  });
  FinderDriverState copyWith({
    FinderDriverStatus? finderDriverStatus,
    String? formTime,
    bool isClearPolyline = false,
    bool? isSearch,
    BitmapDescriptor? markerIcon,
    List<LatLng>? polylinePoints,
    Set<Polyline>? polylines,
    Set<Circle>? circles,
    PolylineModel? polylineModel,
    bool? isCheck,
    String? error,
    dynamic polyline,
    int? currenIndex,
    int? indexActive,
    Position? position,
    bool? mapType,
    bool? isForms,
    bool? isStart,
    int? start,
    LatLng? currentCenter,
    List<dynamic>? historySearch,
    int? index,
    bool? loading,
  }) {
    return FinderDriverState(
      finderDriverStatus: finderDriverStatus ?? this.finderDriverStatus,
      isCheck: isCheck ?? this.isCheck,
      error: error ?? this.error,
      mapType: mapType ?? this.mapType,
      polyline: polylines ?? this.polyline,
      currenIndex: currenIndex ?? this.currenIndex,
      currentCenter: currentCenter ?? this.currentCenter,
      indexActive: indexActive ?? this.indexActive,
      polylineDataModel: polylineModel ?? this.polylineDataModel,
      index: index ?? this.index,
      isForms: isForms ?? this.isForms,
      isStart: isStart ?? this.isStart,
      isSearch: isSearch ?? this.isSearch,
      start: start ?? this.start,
      loading: loading ?? this.loading,
      markerIcon: markerIcon ?? this.markerIcon,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      polylines: isClearPolyline ? null : polylines ?? this.polylines,
      historySearch: historySearch ?? historySearch,
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
    polyline,
    isForms,
    isStart,
    isSearch,
    polylineDataModel,
    start,
    markerIcon,
    polylinePoints,
    polylines,
    circles,
    indexActive,
    index,
    loading,
    historySearch,
  ];
}
