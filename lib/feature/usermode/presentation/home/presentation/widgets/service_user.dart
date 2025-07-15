import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/constants/app_constants.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/order_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/order_state.dart';
import 'package:nav_service/nav_service.dart';

import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';

class ServiceUser extends StatefulWidget {
  const ServiceUser({super.key});

  @override
  State<ServiceUser> createState() => _ServiceUserState();
}

class _ServiceUserState extends State<ServiceUser> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.homeStatus == HomeStatus.failure) {}
      },

      builder: (context, state) {
        return GridView.builder(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.1,
            crossAxisSpacing: 10,
          ),
          itemCount: state.services!.length,
          itemBuilder: (context, index) {
            final data = state.services;
            return BlocConsumer<OrderCubit, OrderState>(
              listener: (BuildContext context, OrderState state) {
                if (state.orderStatus == OrderStatus.failure) {}
              },
              builder: (context, state) {
                var cubit = context.read<OrderCubit>();
                return GestureDetector(
                  onTap: () {
                    cubit.getUserSurverDriver();
                    //cubit.socketConnect();
                  },
                  child:
                       Card(
                            elevation: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      AppConstants.imageUrl +
                                      data![index].icon.toString(),
                                  fit: BoxFit.cover,
                                  height: 50,
                                ),

                                Text(
                                  data[index].name.toString(),

                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                );
              },
            );
          },
        );
      },
    );
  }
}
