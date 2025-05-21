import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart';

class BannerDriver extends StatefulWidget {
  const BannerDriver({super.key});

  @override
  State<BannerDriver> createState() => _BannerDriverState();
}

class _BannerDriverState extends State<BannerDriver> {
  List<String> banner = [
    "assets/images/drivermode/banner1.png",
    "assets/images/drivermode/banner2.png",
  ];
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Column(children: [_banner(), SizedBox(height: 5)]);
  }

  _banner() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,

        viewportFraction: 1,
        onPageChanged: (index, reson) {
          setState(() {
            _current = index;
          });
        },
      ),
      items:
          banner
              .map(
                (i) => Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(i, fit: BoxFit.cover),
                  ),
                ),
              )
              .toList(),
    );
  }

 
}
