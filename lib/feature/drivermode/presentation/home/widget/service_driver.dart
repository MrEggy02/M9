import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:m9/feature/drivermode/cubit/driver_cubit.dart';
import 'package:m9/feature/drivermode/presentation/meter/cubit/meter_cubit.dart';
import 'package:m9/feature/drivermode/presentation/meter/page/meter_page.dart';
import 'package:m9/feature/drivermode/presentation/payment/page/payment_page.dart';
import 'package:m9/feature/drivermode/presentation/registerOnline/widget/webview_register.dart';
import 'package:m9/feature/drivermode/presentation/tracking/page/tracking_driver.dart';
import 'package:m9/feature/usermode/presentation/home/cubit/home_cubit.dart';
import 'package:m9/feature/usermode/presentation/home/cubit/home_state.dart';

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
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.homeStatus == HomeStatus.failure) {
          print('login error=>${state.error}');
        }
      },
      builder: (context, state) {
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
            final data = serviceData;
            return GestureDetector(
              onTap: () {
                if (index == 0) {
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PaymentPage()),
                  );
                } else if (index == 2) {
                } else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create:
                                (BuildContext context) =>
                                    MeterCubit(context: context),
                            child: const MeterPage(),
                          ),
                    ),
                  );
                } else if (index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create:
                                (BuildContext context) =>
                                    DriverCubit(context: context)..loadWebView(
                                      url: 'https://m9.skvgroup.online/order',
                                    ),
                            child: const LoadingWebView(),
                          ),
                    ),
                  );
                }
              },
              child: Card(
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(data[index]['icon'], height: 50),
                    Text(data[index]['title'], style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
