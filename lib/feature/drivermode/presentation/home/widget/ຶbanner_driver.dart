import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/constants/app_constants.dart';

import 'package:m9/feature/usermode/presentation/home/cubit/home_cubit.dart';
import 'package:m9/feature/usermode/presentation/home/cubit/home_state.dart';

class BannerDriver extends StatefulWidget {
  const BannerDriver({super.key});

  @override
  State<BannerDriver> createState() => _BannerDriverState();
}

class _BannerDriverState extends State<BannerDriver> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.homeStatus == HomeStatus.failure) {
          print('login error=>${state.error}');
        }
      },
      builder: (context, state) {
        var size = MediaQuery.of(context).size;
        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: size.height / 5,
                autoPlay: true,

                viewportFraction: 1,
                onPageChanged: (index, reson) {
                  setState(() {
                    current = index;
                  });
                },
              ),
              items:
                  state.banners!
                      .map(
                        (i) => Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  AppConstants.imageUrl + i.image.toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            SizedBox(height: 5),
          ],
        );
      },
    );
  }
}
