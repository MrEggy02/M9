import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/page/polyline/widget/card_finder_driver.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/widget/popup_select_map.dart';

class BottomPolylineFinderDriver extends StatefulWidget {
  const BottomPolylineFinderDriver({super.key});

  @override
  State<BottomPolylineFinderDriver> createState() =>
      _BottomPolylineFinderDriverState();
}

class _BottomPolylineFinderDriverState
    extends State<BottomPolylineFinderDriver> {


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<FinderDriverCubit, FinderDriverState>(
      listener: (context, state) {
        if (state.finderDriverStatus == FinderDriverStatus.failure) {}
      },
      builder: (context, state) {
        var cubit = context.read<FinderDriverCubit>();
        return SingleChildScrollView(
          child: Container(
            height: size.height / 2,
            decoration: BoxDecoration(
              color:  Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(2, 4), // ແນວຕັ້ງ x, ແນວນອນ y
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: 
                  Container(
                    height: size.height / 12,
                    width: size.width / 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    child: Column(
                      children: [
                        Text("ລາຄາແນະນຳ", style: TextStyle(fontSize: 13)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
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
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.banknote300,
                                    color: AppColors.primaryColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Text(
                                      "${cubit.carType[cubit.indexActive]['price']} LAK",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                
                ),
                Text("ເລືອກປະເພດລົດ"),

                /// -
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.all(0),
                    itemCount: cubit.carType.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                cubit.onTapCarType(index);
                              },
                              child: Container(
                                height: size.height / 18,
                                decoration: BoxDecoration(
                                  color:
                                      cubit.indexActive == index
                                          ? Colors.grey.shade200
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          cubit.carType[index]['icon'],
                                          fit: BoxFit.cover,
                                          height: 18,
                                          width: 30,
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(cubit.carType[index]['title']),
                                            Row(
                                              children: [
                                                Icon(Icons.person, size: 15),
                                                Text(
                                                  cubit.carType[index]['amount']
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Center(
                                        child: Text(
                                          "~ ₭${cubit.carType[index]['price']}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade200,
                              indent: 10,
                              endIndent: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(
                        "ລາຄາອັດຕະໂນມັດ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        "₭${cubit.carType[cubit.indexActive]['price']}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      cubit.onLoading(true);
                     // cubit.startTimer();
                    },
                    child: Container(
                      height: size.height / 16,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child:
                            cubit.isLoading == true
                                ? CircularProgressIndicator(color: Colors.black)
                                : Text(
                                  "ເອີ້ນລົດ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
