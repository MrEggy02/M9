import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';
import 'package:nav_service/nav_service.dart';

class ReviewFinderDriver extends StatelessWidget {
  const ReviewFinderDriver({super.key});

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
        
        return AlertDialog(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "ໄວທີ່ຫຼັງ",
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    NavService.pop();
                    cubit.scaffoldKey = null;
                    Navigator.pushNamed(context, AppRoutes.homepage);
                    
                  },
                  child: Text(
                    "ໃຫ້ຄະແນນ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
          content: SizedBox(
            height: size.height / 4,
            width: size.width / 3,
           
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/usermode/Artwork.png",
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "ເດີນທາງຮອດຈຸດໝາຍ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text("ທ່ານໄດ້ເດີນທາງຮອດຈຸດໝາຍປາຍທາງແລ້ວ"),
                Text("ໃຫ້ຄະແນນກັບຜູ້ຂັບ ?"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: AnimatedRatingStars(
                    initialRating: 1,
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
                    starSize: 22.0,
                    animationDuration: Duration(milliseconds: 300),
                    animationCurve: Curves.easeInOut,
                    readOnly: false,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
