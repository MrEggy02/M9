import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/%E0%BA%B6banner_driver.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/drawer_driver.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/header_driver.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/service_driver.dart';

class HomeDriver extends StatefulWidget {
  const HomeDriver({super.key});

  @override
  State<HomeDriver> createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      key: scaffoldKey,
      drawer: DrawerDriver(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderDriver(scaffold: scaffoldKey),
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
            ServiceDriver(),
          ],
        ),
      ),
    );
  }
}
