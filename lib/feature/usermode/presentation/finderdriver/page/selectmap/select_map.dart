import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';
import 'package:nav_service/nav_service.dart';

class SelectMap extends StatefulWidget {
  const SelectMap({super.key});

  @override
  State<SelectMap> createState() => _SelectMapState();
}

class _SelectMapState extends State<SelectMap> {
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
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: cubit.currentCenter!,
                  zoom: 14,
                ),
                onCameraMove: cubit.onCameraMove,
                onCameraIdle: cubit.onCameraIdle,
                myLocationEnabled: true,
                mapToolbarEnabled: true,
                myLocationButtonEnabled: false,
              ),

              Center(
                child: Image.asset('assets/icons/pin.png', fit: BoxFit.cover),
              ),

              // 🔄 Loading indicator
              Positioned(
                top: 60,
                left: 15,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(child: Icon(Icons.arrow_back, size: 30)),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 15,
                right: 15,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                     // cubit.fetchAndDisplayRoute();
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.polylinefinderdriver,
                      );
                    },
                    child: Container(
                      height: size.height / 16,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child:
                            state.finderDriverStatus ==
                                    FinderDriverStatus.loading
                                ? CircularProgressIndicator(color: Colors.black)
                                : Text(
                                  "ສຳເລັດ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
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
