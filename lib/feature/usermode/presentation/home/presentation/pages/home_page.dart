import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/%E0%BA%B6banner_driver.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/drawer_driver.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/header_driver.dart';
import 'package:m9/feature/drivermode/presentation/home/widget/service_driver.dart';
import 'package:m9/feature/usermode/presentation/home/presentation/widgets/drawer_user.dart';
import 'package:m9/feature/usermode/presentation/home/presentation/widgets/header_user.dart';
import 'package:m9/feature/usermode/presentation/home/presentation/widgets/service_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
