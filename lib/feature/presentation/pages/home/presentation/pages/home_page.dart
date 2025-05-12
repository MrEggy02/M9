import 'package:flutter/material.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/feature/presentation/pages/home/bloc/home_bloc.dart';
import 'package:provider/provider.dart';

import '../widgets/profile_card.dart';
import '../widgets/slider_banner.dart';
import '../widgets/service_category.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ນຳໃຊ້ Consumer ເພື່ອຟັງການປ່ຽນແປງສະຖານະຈາກ HomeBloc
    return Consumer<HomeBloc>(
      builder: (context, homeBloc, _) {
        final state = homeBloc.state;
        
        // ສະແດງຕົວໂຫຼດຂໍ້ມູນຖ້າກຳລັງໂຫຼດຢູ່
        if (state.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFFCC00),
              ),
            ),
          );
        }
        
        // ສະແດງຂໍ້ຜິດພາດຖ້າມີ
        if (state.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => homeBloc.loadHomeData(),
                    child: const Text('ລອງໃໝ່'),
                  ),
                ],
              ),
            ),
          );
        }
        
        // ສະແດງໜ້າຫຼັກ
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                // ເປີດເມນູດ້ານຂ້າງ
              },
            ),
            actions: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chat, color: Colors.black),
                    onPressed: () {
                      // ເປີດຫນ້າຂໍ້ຄວາມ
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ແຖບໂປຣໄຟລ໌ຜູ້ໃຊ້
                GestureDetector(
                  onTap: () => homeBloc.openProfile(),
                  child: ProfileCard(user: state.user),
                ),
                
                // ແຖບສະໄລເດີ້ໂຄສະນາ
                SliderBanner(banners: state.banners),
                
                // ຊື່ຫົວຂໍ້ບໍລິການ M9
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      const Text(
                        'ບໍລິການ M9',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 2,
                        color: const Color(0xFFFFCC00),
                        margin: const EdgeInsets.only(top: 4),
                      ),
                    ],
                  ),
                ),
                
                // ແຖວໄອຄອນບໍລິການ
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: state.services.map((service) {
                      // ສ້າງປຸ່ມບໍລິການແຕ່ລະປະເພດ
                      IconData icon = Icons.local_taxi;
                      switch (service.id) {
                        case '1':
                          icon = Icons.local_taxi;
                          break;
                        case '2':
                          icon = Icons.location_on;
                          break;
                        case '3':
                          icon = Icons.local_shipping;
                          break;
                      }
                      
                      return GestureDetector(
                        onTap: () => homeBloc.selectService(service),
                        child: ServiceCategory(
                          icon: icon,
                          title: service.name,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                // ພື້ນທີ່ວ່າງສຳລັບເນື້ອຫາເພີ່ມເຕີມ
                const SizedBox(height: 300),
              ],
            ),
          ),
        );
      },
    );
  }
}