import 'dart:convert';
import 'dart:typed_data';

import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:m9/core/config/theme/app_color.dart';

import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/widget/bottom_finder_driver.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/page/polyline/widget/bottom_polyline_finder_driver.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/page/polyline/widget/bottom_tracking_finder_driver.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/page/polyline/widget/card_finder_driver.dart';

import 'package:m9/feature/usermode/presentation/finderdriver/widget/drawer_finder_driver.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../cubit/finder_driver_cubit.dart';

class PolylineFinderDriver extends StatefulWidget {
  const PolylineFinderDriver({super.key});

  @override
  State<PolylineFinderDriver> createState() => _PolylineFinderDriverState();
}

class _PolylineFinderDriverState extends State<PolylineFinderDriver> {
  //final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<FinderDriverCubit, FinderDriverState>(
      listener: (context, state) {
        if (state.finderDriverStatus == FinderDriverStatus.failure) {
          print('Error: ${state.error}');
        }
      },
   
      builder: (context, state) {
        var cubit = context.read<FinderDriverCubit>();
      
        return Scaffold(
        
          backgroundColor: Colors.grey.shade100,
          bottomNavigationBar:
              cubit.Index == 1
                  ? SizedBox()
                  : cubit.Index == 2
                  ? BottomTrackingFinderDriver()
                  : BottomPolylineFinderDriver(),
          body: Stack(
            children: [
              MapWidget(
                key: ValueKey("mapWidget"),
                onMapCreated: (MapboxMap map) {
                  cubit.mapboxMap = map;
              
                  // Enable location tracking
                  cubit.mapboxMap!.location.updateSettings(
                    LocationComponentSettings(
                      enabled: true,
                      pulsingEnabled: true,
                    ),
                  );
                },
              
                onMapIdleListener: (mapIdleEventData) {},
                styleUri: MapboxStyles.MAPBOX_STREETS,
                cameraOptions: CameraOptions(
                 
                  center: Point(
                    coordinates: Position(
                      cubit.currentPositionLatLng.longitude,
                      cubit.currentPositionLatLng.latitude,
                    ),
                  ),
                  zoom: 13,
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                left: 20,
                child: Container(
                  height: size.height / 11,
                  width: size.width / 1.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/pin.png',
                              height: 20,
                              width: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Text(
                                "ຈາກ",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                child: Text(
                                  "ທາງເຂົ້າ",
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/redpin.png',
                              height: 20,
                              width: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Text(
                                "ທາດຫຼວງ",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.add, size: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              cubit.isLoading == false
                  ? SizedBox()
                  : Positioned(
                    top: 0,
                    right: 2,
                    left: 2,
                    child: Container(
                      height: size.height / 1,
                      width: size.width / 1,
                      decoration: BoxDecoration(color: Colors.black45),
                    ),
                  ),
              cubit.isLoading == false
                  ? SizedBox()
                  : ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return CardFinderDriver();
                    },
                  ),

              // 🔄 Loading indicator
              cubit.Index == 2
                  ? SizedBox()
                  : Positioned(
                    bottom: 20,
                    left: 10,
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
              cubit.Index == 2
                  ? Positioned(
                    bottom: 20,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Icon(LucideIcons.route, size: 25),
                        ),
                      ),
                    ),
                  )
                  : Positioned(
                    bottom: 20,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        if (cubit.Index == 0) {
                          cubit.onTap(1);
                        } else {
                          cubit.onTap(0);
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Icon(LucideIcons.navigation, size: 25),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
