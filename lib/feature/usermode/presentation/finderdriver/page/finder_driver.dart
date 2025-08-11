import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/order_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/order_state.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/widget/bottom_finder_driver.dart';

import 'package:m9/feature/usermode/presentation/finderdriver/widget/drawer_finder_driver.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/widget/popup_select_map.dart';
import 'package:map_location_picker/map_location_picker.dart';

import '../cubit/finder_driver_cubit.dart';

class FinderDrivder extends StatefulWidget {
  const FinderDrivder({super.key});

  @override
  State<FinderDrivder> createState() => _FinderDrivderState();
}

class _FinderDrivderState extends State<FinderDrivder> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // Position? currentPositionLatLng;
  // LatLng _currentCenter = LatLng(17.981420079241147, 102.61872346865296);
  List<LatLng> _points = [];
  String? streetName;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FinderDriverCubit, FinderDriverState>(
      listener: (context, state) {
        if (state.finderDriverStatus == FinderDriverStatus.failure) {
          print('Failure');
        }
      },

      builder: (context, state) {
        var cubit = context.read<FinderDriverCubit>();

        return Scaffold(
          key: scaffoldKey,
          drawer: DrawerFinderDriver(),
          backgroundColor: Colors.grey.shade100,
          bottomNavigationBar:
              cubit.currenIndex == 1
                  ? SizedBox()
                  : BottomFinderDriver(scaffoldKey: scaffoldKey),
          body: BlocConsumer<OrderCubit, OrderState>(
            listener: (context, stateOrder) {
              if (stateOrder.orderStatus == OrderStatus.failure) {
                print('Failure');
              }
            },

            builder: (context, stateOrder) {
              return Stack(
                children: [
                  // currentPositionLatLng == null
                  //     ? Center(child: CircularProgressIndicator())
                  //     :
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: cubit.currentCenter,
                      zoom: 15,
                    ),

                    mapType:
                        cubit.isMapType == true
                            ? MapType.hybrid
                            : MapType.normal,
                    onCameraMove: (CameraPosition position) {
                      cubit.currentCenter = position.target;
                    },
                    onCameraIdle: () async {
                      _points.add(cubit.currentCenter);
                      LatLng lastPoint = _points.last;
                      print('ຕຳແໜ່ງສຸດທ້າຍ: $lastPoint');
                      cubit.getCurrentLocation();
                      // Reverse geocoding

                      setState(() {
                        cubit.currentCenter = lastPoint;
                      });
                    },

                    myLocationEnabled: true,
                    mapToolbarEnabled: true,
                    myLocationButtonEnabled: false,
                  ),

                  Center(
                    child: Image.asset(
                      'assets/icons/pin.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // 🔄 Loading indicator
                  Positioned(
                    top: 60,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        scaffoldKey.currentState!.openDrawer();
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(child: Icon(Icons.menu, size: 30)),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 60,
                    right: 15,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Center(child: Icon(Icons.chat_outlined, size: 30)),
                          Positioned(
                            top: 5,
                            right: 10,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text(
                                  "3",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        if (cubit.currenIndex == 0) {
                          cubit.onTapForm(1);
                        } else {
                          cubit.onTapForm(0);
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
                          child: Icon(
                            Icons.near_me_outlined,
                            size: 30,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 80,
                    right: 10,
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
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.map_outlined,
                            size: 30,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
