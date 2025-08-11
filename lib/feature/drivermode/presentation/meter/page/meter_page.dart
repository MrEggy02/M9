import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/drivermode/presentation/meter/cubit/meter_cubit.dart';
import 'package:m9/feature/drivermode/presentation/meter/cubit/meter_state.dart';
import 'package:m9/feature/drivermode/presentation/meter/widget/start_map.dart';
import 'package:slide_to_act/slide_to_act.dart';

class MeterPage extends StatefulWidget {
  const MeterPage({super.key});

  @override
  State<MeterPage> createState() => _MeterPageState();
}

class _MeterPageState extends State<MeterPage> {
  Position? currentPositionLatLng;
  LatLng _currentCenter = LatLng(17.98125680230435, 102.61842306125011);
  List<LatLng> _points = [];
  Set<Marker> _markers = {};
  BitmapDescriptor? _customMarker;
  @override
  void initState() {
    super.initState();
    loadCustomMarker();
    getCurrentLocation();
  }

  Future<void> loadCustomMarker() async {
    // ignore: deprecated_member_use
  
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(124, 124)),
      'assets/icons/car2.png',

    );

    setState(() {
      _customMarker = icon;
      // ອັບເດດ marker ທັນທີ່ມີ icon
      _markers = {
        Marker(
          markerId: const MarkerId('position'),
          position: _currentCenter,
          icon: _customMarker!,
        ),
      };
    });
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentPositionLatLng = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeterCubit, MeterState>(
      listener: (context, state) {
        if (state.meterStatus == MeterStatus.failure) {}
      },
      builder: (context, state) {
        var cubit = context.read<MeterCubit>();
        if (state.meterStatus == MeterStatus.loading ||
            state.polylines == null) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                polylines: state.polylines!,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: _markers,
                mapType:
                    cubit.isMapType == true ? MapType.hybrid : MapType.normal,
                zoomControlsEnabled: false,
                onMapCreated: (controller) {
                  cubit.controllerMap = controller;
                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {});
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: _currentCenter,
                  zoom: 16,
                ),
              ),
              Positioned(
                bottom: 290,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    if (cubit.isMapType == true) {
                      setState(() {
                        cubit.onTapMapType(false);
                      });
                    } else {
                      setState(() {
                        cubit.onTapMapType(true);
                      });
                    }
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(child: Icon(LucideIcons.map, size: 28)),
                  ),
                ),
              ),
              Positioned(
                bottom: 220,
                right: 20,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(child: Icon(Icons.cable_rounded, size: 25)),
                  ),
                ),
              ),

              Positioned(
                top: 60,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(child: Icon(Icons.arrow_back, size: 25)),
                  ),
                ),
              ),

              state.isStart == true
                  ? StartMap()
                  : Positioned(
                    bottom: 30,
                    right: 15,
                    left: 15,
                    child: SlideAction(
                      height: 60,
                      borderRadius: 20,
                      text: "ເລີ່ມຕົ້ນທຳງານ",
                      textStyle: TextStyle(fontSize: 18),
                      outerColor: AppColors.primaryColor,
                      innerColor: Colors.black,
                      onSubmit: () {
                        cubit.onTap(true);
                        // ໃສ່ການດໍາເນີນການທີ່ນີ້

                        return null;
                      },
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
