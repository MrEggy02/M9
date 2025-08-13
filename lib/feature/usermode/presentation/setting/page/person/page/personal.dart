import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/core/config/theme/app_theme.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/usermode/presentation/setting/page/person/widget/date_personal_widget.dart';
import 'package:m9/feature/usermode/presentation/setting/page/person/widget/gender_personal_widget.dart';
import 'package:m9/feature/usermode/presentation/setting/page/person/widget/txt_personal_widget.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  String? selectedGender;

  // Convert ISO date format to readable format
  String formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return isoDate;
    }
  }

  // Convert date format back to ISO
  String parseToIsoDate(String date) {
    if (date.isEmpty) return '';
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]) ?? 1;
        final month = int.tryParse(parts[1]) ?? 1;
        final year = int.tryParse(parts[2]) ?? 2000;
        return DateTime(year, month, day).toIso8601String();
      }
      return date;
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.failure) {
          print("====>${state.error}");
        }
      },
      builder: (context, state) {
        var cubit = context.read<AuthCubit>();
        return Scaffold(
          bottomNavigationBar: Container(
            height: 120,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "ບັນທຶກ",
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
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'ຂໍ້ມູນສ່ວນຕົວ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [],
          ),
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              // Update controllers when new user data is received
              if (state.authStatus == AuthStatus.failure) {}
            },
            builder: (context, state) {
              // Show loading spinner while fetching initial data
              if (state.authStatus == AuthStatus.loading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('ກຳລັງໂຫຼດຂໍ້ມູນ...'),
                    ],
                  ),
                );
              }

              // Show main content
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ຂໍ້ມູນທົ່ວໄປ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Form fields - Only the fields that exist in your database
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: TxtPersonalWidget(
                                icon: Icons.badge_rounded,
                                type: TextInputType.name,
                                name: "ປ້ອນຂໍ້ມູນຜູ້ໃຊ້",
                                controller: cubit.username,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: TxtPersonalWidget(
                                icon: Icons.badge_rounded,
                                type: TextInputType.name,
                                name: "ປ້ອນຊື່",
                                controller: cubit.firstName,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: TxtPersonalWidget(
                                icon: Icons.badge_rounded,
                                type: TextInputType.name,
                                name: "ປ້ອນນາມສະກຸນ",
                                controller: cubit.lastName,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: TxtPersonalWidget(
                                icon: Icons.email_outlined,
                                type: TextInputType.emailAddress,
                                name: "ປ້ອນອີເມວ",
                                controller: cubit.email,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: DatePersonalWidget(),
                            ),

                            const SizedBox(height: 16),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'ເພດ/ທີ່ຢູ່',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                            GenderPersonalWidget(),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: TxtPersonalWidget(
                                icon: Icons.pin_drop_sharp,
                                type: TextInputType.name,
                                name: "ປ້ອນບ້ານເມືອງແຂວງ",
                                controller: cubit.addressController,
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),

                    // Save button - Always visible when editing
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFECE0C),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'ບັນທຶກການປ່ຽນແປງ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Editable field for name only
  Widget buildEditableField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFECE0C), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800]),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 16),
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }
}
