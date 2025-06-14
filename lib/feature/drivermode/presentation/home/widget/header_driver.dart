import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart';

class HeaderDriver extends StatelessWidget {
  final scaffold;
  const HeaderDriver({super.key, required this.scaffold});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height / 2.6,
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
            onTap: (){
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
            height: size.height / 4.6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "ກມ 9988 ນະຄອນຫຼວງວຽງຈັນ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text("ຈຳນວນ:", style: TextStyle(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Text(
                          "142 ຖ້ຽວ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("ຍອດເງີນ:", style: TextStyle(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Text(
                          "28,500,000 ກີບ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "ຍອດເງີນໄດ້ຮັບຕົວຈິ່ງ:",
                        style: TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Text(
                          "25,500,000 ກີບ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
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
