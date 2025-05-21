import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:m9/feature/drivermode/presentation/tracking/page/tracking_driver.dart';

class ServiceDriver extends StatefulWidget {
  const ServiceDriver({super.key});

  @override
  State<ServiceDriver> createState() => _ServiceDriverState();
}

class _ServiceDriverState extends State<ServiceDriver> {
  List<dynamic> serviceData = [
    {"icon": "assets/images/drivermode/car.png", "title": "ແລ່ນລົດ"},
    {"icon": "assets/images/drivermode/income.png", "title": "ລາຍຮັບ-ລາຍຈ່າຍ"},
    {"icon": "assets/images/drivermode/delivery.png", "title": "ຈັດສົ່ງສິນຄ້າ"},
    {"icon": "assets/images/drivermode/mitter.png", "title": "ມິດເຕີ"},
    {"icon": "assets/images/drivermode/history.png", "title": "ປະຫວັດແລ່ນລົດ"},
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
