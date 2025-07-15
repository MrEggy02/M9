import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/%E0%BA%B6banner_driver.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/drawer_driver.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/header_driver.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/service_driver.dart';
import 'package:m9/feature/usermode/presentation/home/presentation/widgets/drawer_user.dart';
import 'package:m9/feature/usermode/presentation/home/presentation/widgets/header_user.dart';
import 'package:m9/feature/usermode/presentation/home/presentation/widgets/service_user.dart';
import 'package:map_location_picker/map_location_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  Future<Position?> getPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      showMyDialog();

      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }
    Position? position = await Geolocator.getLastKnownPosition();

    if (position != null) {
      return position;
    } else {
      return await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );
    }
  }

  // // Alert dialog opening when getPermission() return null
  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  "M9 driver",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'collects location data to allow tracking when there is no internet and records your location while traveling online and offline, even when the app is closed or not in use.',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryColorBlack,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: const Text(
                    'DENY',
                    style: TextStyle(color: AppColors.primaryColorBlack),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                Spacer(),
                TextButton(
                  child: const Text(
                    'ACCEPT',
                    style: TextStyle( color: AppColors.primaryColor,),
                  ),
                  onPressed: () {
                    Geolocator.requestPermission();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      key: scaffoldKey,
      drawer: DrawerUser(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderUser(scaffold: scaffoldKey),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: BannerDriver(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "ບໍລິການ M9",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDCA315),
                ),
              ),
            ),
            Divider(color: Color(0xFFDCA315), endIndent: 18, indent: 18),
            ServiceUser(),
          ],
        ),
      ),
    );
  }
}
