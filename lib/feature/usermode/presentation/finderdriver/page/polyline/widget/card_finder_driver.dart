import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';

class CardFinderDriver extends StatelessWidget {
  const CardFinderDriver({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<FinderDriverCubit, FinderDriverState>(
      listener: (context, state) {
        if (state.finderDriverStatus == FinderDriverStatus.failure) {
          print('Error: ${state.error}');
        }
      },

      builder: (context, state) {
        var cubit = context.read<FinderDriverCubit>();
        return SizedBox(
          height: size.height / 4.6,
          width: double.infinity,

          child: Stack(
            children: [
              Positioned(
                right: 20,
                left: 20,
                child: Container(
                  height: size.height / 5,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.asset(
                                      "assets/images/usermode/profile.jpg",
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ຊາຍວຸດ ໂສມນະນົງ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "ກມ 5959",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "ນະຄອນຫຼວງວຽງຈັນ",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  SizedBox(width: 20),
                                  Text(
                                    "₭",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    "${cubit.carType[cubit.indexActive]['price']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          cubit.onLoading(false);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "ປະຕິເສດ",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: GestureDetector(
                                          onTap: (){
                                            cubit.onTap(2);
                                            cubit.onLoading(false);
                                            
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor,
                                              borderRadius: BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "ຍອມຮັບ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "ຄະແນນລີວິວ:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: AnimatedRatingStars(
                                      initialRating: 3,
                                      minRating: 0,
                                      maxRating: 5.0,
                                      filledColor: AppColors.primaryColor,
                                      emptyColor: Colors.grey,
                                      filledIcon: Icons.star,
                                      halfFilledIcon: Icons.star_half,
                                      emptyIcon: Icons.star_border,
                                      onChanged: (double rating) {
                                        // Handle the rating change here
                                        print('Rating: $rating');
                                      },
                                      displayRatingValue: true,
                                      interactiveTooltips: true,
                                      customFilledIcon: Icons.star,
                                      customHalfFilledIcon: Icons.star_half,
                                      customEmptyIcon: Icons.star_border,
                                      starSize: 12.0,
                                      animationDuration: Duration(
                                        milliseconds: 300,
                                      ),
                                      animationCurve: Curves.easeInOut,
                                      readOnly: true,
                                    ),
                                  ),
                                 
                                  Text(
                                    "/100 ຖ້ຽວ",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Positioned(
                          top: 5,
                          right: 5,
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.history300,
                                color: AppColors.primaryColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: Text("15 ນາທີ"),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 5,
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.map300,
                                color: AppColors.primaryColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: Text("25 KM"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
