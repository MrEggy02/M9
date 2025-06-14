import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/widget/popup_select_map.dart';

class BottomFinderDriver extends StatefulWidget {
  const BottomFinderDriver({super.key});

  @override
  State<BottomFinderDriver> createState() => _BottomFinderDriverState();
}

class _BottomFinderDriverState extends State<BottomFinderDriver> {
  int currentIndex = 0;
  void _ontap(index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<dynamic> carType = [
    {"icon": "assets/images/usermode/car.png", "title": "ລົດໂດຍສານ"},
    {"icon": "assets/images/usermode/ev.png", "title": "ລົດໄຟຟ້າ EV"},
    {"icon": "assets/images/usermode/motobike.png", "title": "ລົດຈັກ"},
    {"icon": "assets/images/usermode/delivery.png", "title": "ຈັດສົ່ງສິນຄ້າ"},
  ];

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
            height: size.height / 2.2,
            decoration: BoxDecoration(
              color: Colors.white,
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
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Container(
                    height: size.height / 10,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            carType.map((data) {
                              int index = carType.indexOf(data);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _ontap(index);
                                  },
                                  child: Container(
                                    height: size.height / 12,
                                    width: size.width / 5,
                                    decoration: BoxDecoration(
                                      color:
                                          currentIndex == index
                                              ? Colors.white
                                              : Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(data['icon']),
                                        Text(
                                          data['title'],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Image.asset("assets/images/usermode/drop.png"),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return Text(
                                '•',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Image.asset(
                              "assets/images/usermode/location_on.png",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: size.height / 13,
                          width: size.width / 1.2,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF4E1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ຈາກ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  "Huayhong Road",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              cubit.onTapForm(1);
                              cubit.scaffoldKey!.currentState?.showBottomSheet((
                                context,
                              ) {
                                return PopUpSelectMap();
                              });
                            },
                            child: Container(
                              height: size.height / 13,
                              width: size.width / 1.2,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFF4E1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ໄປທີ່",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.search_outlined,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 2),
                                        Text(
                                          "ປ້ອນຕຳແໜ່ງທີ່ຕ້ອງການໄປ...",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      cubit.onTapForm(1);
                      //cubit.scaffoldKey = null;
                      cubit.scaffoldKey!.currentState?.showBottomSheet((
                        context,
                      ) {
                        return PopUpSelectMap();
                      });
                    },
                    child: Container(
                      height: size.height / 16,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "ຄົ້ນຫາຄົນຂັບ",
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
