import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart' show AppColors;

class DrawerUser extends StatefulWidget {
  const DrawerUser({super.key});

  @override
  State<DrawerUser> createState() => _DrawerUserState();
}

class _DrawerUserState extends State<DrawerUser> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        children: [
          // Top decoration container
          Container(
            height: size.height / 6,
            width: double.infinity,
            decoration: BoxDecoration(color: Color(0xFFF7DCB2)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: AppColors.primaryColor,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset("assets/images/usermode/profile.jpg")),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Saiyvoud Somnanong",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("+856 20 96794376",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ListTile items in a scrollable area
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home_outlined),
                  title: const Text('ໜ້າຫຼັກ'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.local_taxi_outlined),
                  title: const Text('ເອີ້ນລົດ'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                 ListTile(
                  leading: Icon(Icons.local_taxi_outlined),
                  title: const Text('ລົດເຊົ່າ-ລົດເໝົາ'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                 ListTile(
                  leading: Icon(Icons.local_taxi_outlined),
                  title: const Text('ຈັດສົ່ງສິນຄ້າ'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history_outlined),
                  title: const Text('ປະຫວັດ'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications_outlined),
                  title: const Text('ການແຈ້ງເຕືອນ'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: const Text('ການຕັ້ງຄ່າ'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: const Text('ຊ່ວຍເຫຼືອ'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // Bottom container - will always stay at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mobile_friendly),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "ໂໝດຜູ້ຂັບ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
