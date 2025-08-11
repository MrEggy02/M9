// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' hide Position;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/core/data/hive/hive_database.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
//import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nav_service/nav_service.dart';

class FinderDriverCubit extends Cubit<FinderDriverState> {
  final BuildContext context;

  FinderDriverCubit({required this.context})
    : super(FinderDriverState(finderDriverStatus: FinderDriverStatus.initial));

  bool mounted = true;
  bool isStart = false;
  int currenIndex = 0;
  int Index = 0;
  final name = TextEditingController();
  final search = TextEditingController();
  GlobalKey<ScaffoldState>? scaffoldKey = GlobalKey<ScaffoldState>();

  Position? currentPosition;
  PointAnnotationManager? annotationManager;
  MapboxMap? mapboxMap;
  List<dynamic> coordinates = [];
  // ---

  @override
  Future<void> close() {
    mounted = false;
    return super.close();
  }

  final second = 60;
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
  var place;
  var road;
  var village;
  var city;
  var province;
  var country;
  bool isMapType = false;
  // -------
  GoogleMapController? controllerMap;
  LatLng currentPositionLatLng = LatLng(17.981420079241147, 102.61872346865296);
  LatLng lastPositionLatLng = LatLng(17.97084758595471, 102.61838014590683);
  // Position? position;
  List<LatLng> polylinePoints = [];
  dynamic polylineData;

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
  Set<Circle> circles = {}; // 🔥 ใช้ Set<Circle> แทน Marker
  List<LatLng> points = [];

  LatLng currentCenter = LatLng(
    18.031547,
    102.647819,
  ); // ຈຸດເລີ່ມຕົ້ນ
  List<LatLng> markerPositions = [];
  int indexActive = 0;
  int start = 25; // ເລີ່ມຈາກ 10 ວິນາທີ
  Timer? timer;
  List<dynamic> searchData = [];
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (start == 0) {
        timer.cancel();
        // ສາມາດເຮັດຢ່າງອື່ນໄດ້ທີ່ນີ້
        print("Countdown Finished!");
        emit(state.copyWith(loading: false));
      } else {
        start--;
        // emit(state.copyWith(start: start));
      }
    });
  }

  void onTapMapType(mapType) {
    isMapType = mapType;
    emit(state.copyWith(mapType: mapType));
  }

  void onTapSearch(bool isSearch) {
    emit(state.copyWith(isSearch: isSearch));
  }

  void onTapCarType(int index) async {
    indexActive = index;
    emit(state.copyWith(indexActive: indexActive));
  }

  void onLoading(loading) async {
    isLoading = loading;
    emit(state.copyWith(loading: isLoading));
  }

  void onTapForm(index) async {
    currenIndex = index;
    emit(state.copyWith(currenIndex: currenIndex));
  }

  void onTap(index) async {
    Index = index;
    emit(state.copyWith(index: Index));
  }

  void onSelectMap(_isStart) async {
    isStart = _isStart;
    emit(state.copyWith(isStart: isStart));
  }

  void onCameraMove(CameraPosition position) {
    currentCenter = position.target;
  }

  void onCameraIdle() {
    points.add(currentCenter);
    LatLng lastPoint = points.last;
    lastPositionLatLng = lastPoint;
    print('ຕຳແໜ່ງສຸດທ້າຍ: $lastPoint');
    emit(
      state.copyWith(
        currentCenter: lastPoint,
        finderDriverStatus: FinderDriverStatus.success,
      ),
    );
  }

  Future<void> saveHistory({
    required String formatted_address,
    required String name,
  }) async {
    try {
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.loading));
      final result = await HiveDatabase.saveSearchMap(
        formatted_address: formatted_address,
        name: name,
      );
      if (result != null) {
        emit(state.copyWith(finderDriverStatus: FinderDriverStatus.success));
      } else {
        emit(state.copyWith(finderDriverStatus: FinderDriverStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.failure));
    }
  }

  Future<void> deleteHistory({required int indexSearch}) async {
    try {
      await HiveDatabase.deleteSearchAt(index: indexSearch);
    } catch (e) {
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.failure));
    }
  }
    Future<void> deleteHistoryAll() async {
    try {
      await HiveDatabase.deleteSearchAll();
    } catch (e) {
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.failure));
    }
  }



  Future<void> getHistory() async {
    try {
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.loading));
      final result = await HiveDatabase.getHistory();
      if (result != null) {
        emit(
          state.copyWith(
            finderDriverStatus: FinderDriverStatus.success,
            historySearch: result,
          ),
        );
      } else {
        emit(state.copyWith(finderDriverStatus: FinderDriverStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.failure));
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.loading));
      // ກວດເບິ່ງສິດກ່ອນ
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      // ດືງພິກັດຕຳແໜ່ງປະຈຸບັນ
      final position = await Geolocator.getCurrentPosition();

      // ແປພິກັດເປັນທີ່ຢູ່
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentCenter.latitude,
        currentCenter.longitude,
      );

      if (placemarks.isNotEmpty) {
        place = placemarks.first;

        road = place.street ?? '';
        village = place.subLocality ?? '';
        city = place.locality ?? '';
        province = place.administrativeArea ?? '';
        country = place.country ?? '';

        print('📍 ຖະໜົນ: $road');
        print('🏘 ບ້ານ: $village');
        print('🏙 ເມືອງ: $city');
        print('🗺 ແຂວງ: $province');
        print('🌍 ປະເທດ: $country');
        emit(state.copyWith(finderDriverStatus: FinderDriverStatus.success));
      } else {
        print('❌ ບໍ່ພົບທີ່ຢູ່');
        emit(state.copyWith(finderDriverStatus: FinderDriverStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.failure));
      print('❌ ມີຂໍ້ຜິດພາດ: $e');
    }
  }

  Future<void> updatePosition() async {
    try {
      controllerMap!.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: currentCenter)),
      );
    } catch (e) {}
  }

  Future<void> addMarker() async {
    try {
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.loading));
      annotationManager =
          await mapboxMap?.annotations.createPointAnnotationManager();

      // Load the image from assets
      final ByteData bytes = await rootBundle.load('assets/icons/pin.png');
      final Uint8List imageData = bytes.buffer.asUint8List();
      final ByteData bytes2 = await rootBundle.load('assets/icons/redpin.png');
      final Uint8List imageData2 = bytes2.buffer.asUint8List();

      // Create a PointAnnotationOptions
      PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            currentPositionLatLng.longitude,
            currentPositionLatLng.latitude,
          ),
        ),
        image: imageData,
        iconSize: 2,
      );
      PointAnnotationOptions pointAnnotationOptions2 = PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            lastPositionLatLng.longitude,
            lastPositionLatLng.latitude,
          ),
        ),
        image: imageData2,
        iconSize: 2,
      );

      // Add the annotation to the map
      await annotationManager?.create(pointAnnotationOptions);
      await annotationManager?.create(pointAnnotationOptions2);
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString(),
          finderDriverStatus: FinderDriverStatus.failure,
        ),
      );
    }
  }

  Future<void> searchPlace(String query) async {
    emit(state.copyWith(finderDriverStatus: FinderDriverStatus.loading));
    final apiKey = 'AIzaSyAgn_fRZwv0tjLG1zyi_s3yCiaTDVzFRcw';
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent(query)}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    //  print("====>${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'];
        searchData = data['results'];
        emit(state.copyWith(finderDriverStatus: FinderDriverStatus.success));
        for (var place in results) {
          print('📍 ${place['name']} - ${place['formatted_address']}');
        }
      } else {
        print('Error: ${data['status']}');
        emit(state.copyWith(finderDriverStatus: FinderDriverStatus.failure));
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.failure));
    }
  }

  Future<List<dynamic>> fetchRoute({
    required String accessToken,
    required String profile,
    required Position origin,
    required Position destination,
  }) async {
    final url = Uri.parse(
      'https://api.mapbox.com/directions/v5/mapbox/$profile/${origin.lng},${origin.lat};${destination.lng},${destination.lat}?geometries=geojson&access_token=$accessToken',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      polylineData = data['routes'][0];
      print(polylineData['duration']);
      emit(state.copyWith(polyline: polylineData));
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        return data['routes'][0]['geometry']['coordinates'];
      } else {
        throw Exception('No routes found.');
      }
    } else {
      throw Exception('Failed to fetch route: ${response.body}');
    }
  }

  Future<void> fetchAndDisplayRoute() async {
    try {
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.loading));
      coordinates = await fetchRoute(
        accessToken: dotenv.env["ACCESS_TOKEN"].toString(),
        profile: "driving",
        origin: Position(
          currentPositionLatLng.longitude,
          currentPositionLatLng.latitude,
        ),
        destination: Position(
          lastPositionLatLng.longitude,
          lastPositionLatLng.latitude,
        ),
      );

      var geoJsonData = {
        "type": "Feature",
        "geometry": {"type": "LineString", "coordinates": coordinates},
      };
      mapboxMap!.style.addSource(
        GeoJsonSource(id: "line", data: json.encode(geoJsonData)),
      );
      // line
      mapboxMap!.style.addLayer(
        LineLayer(
          id: "line-layer",
          sourceId: "line",
          lineColor: AppColors.primaryColor.value,
          lineWidth: 5.0,
        ),
      );
      mapboxMap!.style.addLayer(
        SymbolLayer(id: "line-sysbol", sourceId: "line"),
      );

      await addMarker();
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.success));
    } catch (e) {
      emit(state.copyWith(finderDriverStatus: FinderDriverStatus.failure));
      print('Error fetching or displaying route: $e');
    }
  }
}
