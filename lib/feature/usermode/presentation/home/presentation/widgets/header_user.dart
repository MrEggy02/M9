import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart';

class HeaderUser extends StatelessWidget {
  final scaffold;
  const HeaderUser({super.key, required this.scaffold});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height / 3,
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.primaryColor),
          child: Image.asset(
            "assets/images/drivermode/Background.png",
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 60,
          left: 15,
          child: GestureDetector(
            onTap: () {
              scaffold.currentState!.openDrawer();
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(child: Icon(Icons.menu, size: 30)),
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: 15,
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Center(child: Icon(Icons.chat_outlined, size: 30)),
                Positioned(
                  top: 5,
                  right: 10,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        "3",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: 140,
          left: 15,
          right: 15,
          child: Container(
            height: size.height / 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.asset(
                            "assets/images/usermode/profile.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                         Positioned(
                            bottom: 0,right: 2,
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade200
                              ),
                              child: Icon(Icons.camera_alt,size: 16,),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mr Saiyvoud Somnanong",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "+856 20 96794376",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "142 ຖ້ຽວ",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
