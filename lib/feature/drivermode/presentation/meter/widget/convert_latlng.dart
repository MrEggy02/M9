import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Map fromLatlng(Position ll) {
  return {
    'lat': ll.latitude,
    'lng': ll.longitude,
    'position': ll.toJson(),
  };
}

Map toLatlng(Map ll) {
  return {
    'latlan': LatLng(ll['lat'] ?? 0, ll['long'] ?? 0),
    'position': Position.fromMap(ll['position']),
  };
}