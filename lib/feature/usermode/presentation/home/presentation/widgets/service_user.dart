import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:nav_service/nav_service.dart';

import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';

class ServiceUser extends StatefulWidget {
  const ServiceUser({super.key});

  @override
  State<ServiceUser> createState() => _ServiceUserState();
}

class _ServiceUserState extends State<ServiceUser> {
  List<dynamic> serviceData = [
    {"icon": "assets/images/drivermode/car.png", "title": "ເອີ້ນລົດ","ontap": (){}},
    {"icon": "assets/images/usermode/rental.png", "title": "ລົດເຊົ່າ-ເໝົາລົດ"},
    {"icon": "assets/images/drivermode/delivery.png", "title": "ຈັດສົ່ງສິນຄ້າ"},
  ];
 
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.homeStatus == HomeStatus.failure) {}
      },

      builder: (context, state) {
        var cubit = context.read<HomeCubit>();
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
              NavService.pushReplacementNamed(AppRoutes.find_driver);
               
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
    );
  }
}
