import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';
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
  List<LatLng> points = [];
  LatLng? lastPoint;
  int currentIndex = 0;
  void _ontap(index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<dynamic> carType = [
    {"icon": "assets/images/usermode/car.png", "title": "ລົດໂດຍສານ"},
    {"icon": "assets/images/usermode/ev.png", "title": "ລົດໄຟຟ້າ EV"},
    {"icon": "assets/images/usermode/motobike.png", "title": "ລົດຈັກ"},
    {"icon": "assets/images/usermode/delivery.png", "title": "ຈັດສົ່ງສິນຄ້າ"},
  ];
   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<FinderDriverCubit, FinderDriverState>(
      listener: (context, state) {
        if (state.finderDriverStatus == FinderDriverStatus.failure) {}
      },

      builder: (context, state) {
        var cubit = context.read<FinderDriverCubit>();
        return Scaffold(
          key: scaffoldKey,
          drawer: DrawerFinderDriver(),
          backgroundColor: Colors.grey.shade100,
          bottomNavigationBar:
              cubit.currenIndex == 1 ? SizedBox() : BottomFinderDriver(scaffoldKey: scaffoldKey,),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: cubit.currentCenter,
                  zoom: 18,
                ),
                onCameraMove: cubit.onCameraMove,
                onCameraIdle: cubit.onCameraIdle,
                myLocationEnabled: true,
                mapToolbarEnabled: true,
                myLocationButtonEnabled: false,
              ),

              // Center(
              //   child: SizedBox(
              //     height: 120,
              //     child: Column(
              //       children: [
              //         // Container(
              //         //   height: 50,
              //         //   decoration: BoxDecoration(
              //         //     color: Color(0xFFF7DCB2),
              //         //     borderRadius: BorderRadius.circular(20),
              //         //   ),
              //         //   child: Column(
              //         //     children: [Text("ຖະໜົນ", style: TextStyle())],
              //         //   ),
              //         // ),
              //         Image.asset('assets/icons/pin.png', fit: BoxFit.cover),
              //       ],
              //     ),
              //   ),
              // ),
              Center(
                child: Image.asset('assets/icons/pin.png', fit: BoxFit.cover),
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
                        Icons.near_me,
                        size: 30,
                        color: AppColors.primaryColor,
                      ),
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
