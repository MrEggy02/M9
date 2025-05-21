import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:m9/feature/drivermode/presentation/tracking/page/tracking_driver.dart';

class ServiceUser extends StatefulWidget {
  const ServiceUser({super.key});

  @override
  State<ServiceUser> createState() => _ServiceUserState();
}

class _ServiceUserState extends State<ServiceUser> {
  List<dynamic> serviceData = [
    {"icon": "assets/images/drivermode/car.png", "title": "ເອີ້ນລົດ"},
    {"icon": "assets/images/usermode/rental.png", "title": "ລົດເຊົ່າ-ເໝົາລົດ"},
    {"icon": "assets/images/drivermode/delivery.png", "title": "ຈັດສົ່ງສິນຄ້າ"},
  ];
 
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 10,
      ),
      itemCount: serviceData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrackingDriver()),
            );
           
          },
          child: Card(
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(serviceData[index]['icon'], height: 50),
                Text(
                  serviceData[index]['title'],
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
