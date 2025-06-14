// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final String? error;
  final bool? isCheck;
  final AuthStatus? authStatus;
  final List<LatLng>? polylinePoints;
  final Set<Polyline>? polylines;
  final Set<Circle>? circles;
  final BitmapDescriptor? markerIcon;
  final int? currenIndex;
  final bool? mapType;
  final bool? isForms;
  final bool? isStart;

  const AuthState({
    this.error,
    this.authStatus,
    this.currenIndex,
    this.mapType,
    this.markerIcon,
    this.isCheck = false,
    this.isForms,
    this.isStart,
    this.polylinePoints = const [],
    this.polylines = const {},
    this.circles = const {},
  });
  AuthState copyWith({
    AuthStatus? authStatus,
    String? formTime,
    bool isClearPolyline = false,
    BitmapDescriptor? markerIcon,
    List<LatLng>? polylinePoints,
    Set<Polyline>? polylines,
    Set<Circle>? circles,
    bool? isCheck,
    String? error,
    int? currenIndex,
    Position? position,
    bool? mapType,
    bool? isForms,
    bool? isStart,
    LatLng? currentPositionLatLng,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      isCheck: isCheck ?? this.isCheck,
      error: error ?? this.error,
      mapType: mapType ?? this.mapType,
      currenIndex: currenIndex ?? this.currenIndex,
      isForms: isForms ?? this.isForms,
      isStart: isStart ?? this.isStart,
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
    authStatus,
    currenIndex,
    mapType,
    isForms,
    isStart,
    markerIcon,
    polylinePoints,
    polylines,
    circles,
  ];
}
