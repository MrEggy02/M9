import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/core/routes/app_routes.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_cubit.dart';
import 'package:m9/feature/usermode/presentation/finderdriver/cubit/finder_driver_state.dart';
import 'package:nav_service/nav_service.dart';

class PopUpSelectMap extends StatefulWidget {
  const PopUpSelectMap({super.key});

  @override
  State<PopUpSelectMap> createState() => _PopUpSelectMapState();
}

class _PopUpSelectMapState extends State<PopUpSelectMap> {
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
            height: size.height / 1.05,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "ເສັນທາງທີ່ຕ້ອງການໄປ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        cubit.onTapForm(0);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: size.height / 13,
                    width: size.width / 1.1,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF4E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.my_location_outlined,
                            color: AppColors.primaryColor,
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("ຈາກ", style: TextStyle(color: Colors.grey)),
                            Text(
                              "Huayhong Road",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  flex: 0,
                  child: Container(
                    height: size.height / 13,
                    width: size.width / 1.1,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF4E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.my_location_outlined,
                            color: Colors.indigo,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              label: Text(
                                "ໄປທີ່",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: "ປ້ອນຕຳແຫນ່ງທີ່ຕ້ອງການໄປ",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///--
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 10),
                      child: Icon(
                        Icons.my_location_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextButton(
                        onPressed: () {
                          NavService.pop();
                          Navigator.pushNamed(context, AppRoutes.selectmap);
                          cubit.onTapForm(0);
                        },
                        child: Text(
                          "ເລືອກຢູ່ແຜນທີ",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 8,
                  width: size.width,
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Recent search",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Clear",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 2,

                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.location_on_outlined),
                      title: SizedBox(
                        width: size.width / 2,
                        child: Text(
                          "Thongsangnang chanthabury vientaine",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.close),
                      ),
                    );
                  },
                ),
             
              ],
            ),
          ),
        );
      },
    );
  }
}
