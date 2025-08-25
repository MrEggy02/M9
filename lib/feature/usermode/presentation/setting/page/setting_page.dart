import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
import 'package:m9/core/constants/app_constants.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';

import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/usermode/presentation/home/presentation/widgets/drawer_user.dart';
import 'package:m9/feature/usermode/presentation/setting/page/bank/page/bankaccount.dart';
import 'package:m9/feature/usermode/presentation/setting/page/change/page/changenumber.dart';
import 'package:m9/feature/usermode/presentation/setting/page/lang/page/language.dart';
import 'package:m9/feature/usermode/presentation/setting/page/person/page/personal.dart';
import 'package:m9/feature/usermode/presentation/setting/page/security/page/security.dart';
import 'package:m9/feature/usermode/presentation/setting/page/terms/page/terms.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // ignore: unused_field
  File? _profileImage;

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize profile data when page loads
  //   _loadProfileData();
  // }

  // void _loadProfileData() {
  //   final authCubit = context.read<AuthCubit>();
  //   // Load both profile and bank accounts
  //   authCubit.getProfile();
  //   authCubit.getBankAccounts();
  // }

  // Future<void> _showAddPhotoDialog() async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) => AddPhotoDialog(
  //       onPhotoSelected: (image) {
  //         setState(() {
  //           _profileImage = image;
  //         });
  //       },
  //     ),
  //   );
  // }

  Future<void> _showLogoutConfirmation() async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'ທ່ານຕ້ອງການອອກຈາກລະບົບ ຫຼື ບໍ່?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ບໍ່'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFFECE0C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // Perform logout
                        context.read<AuthCubit>();
                        //   authCubit.deleteAll(); // Clear local data
                        Navigator.pop(context); // Close dialog
                        
                      },
                      child: const Text(
                        'ຕົກລົງ',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ການຕັ້ງຄ່າ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(blurRadius: 1)],
              ),
              child: Center(child: Icon(Icons.menu, size: 25)),
            ),
          ),
        ),
      ),
      drawer: DrawerUser(),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.authStatus == AuthStatus.failure && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'ລອງໃໝ່',
                  textColor: Colors.white,
                  onPressed: () {},
                  //  onPressed: _loadProfileData,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = context.read<AuthCubit>();
          if (state.authStatus == AuthStatus.loading &&
              state.userModel == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFFECE0C)),
                  SizedBox(height: 16),
                  Text('ກຳລັງໂຫຼດຂໍ້ມູນ...'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              cubit.getProfile();
            },
            color: AppColors.primaryColor,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFECE0C), Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 70,
                              height: 70,
                              child:
                                  state.userModel!.displayName == null ||
                                          state.userModel!.avatar == null
                                      ? Image.asset("assets/icons/user2.png")
                                      : CachedNetworkImage(
                                        imageUrl:
                                            AppConstants.imageUrl +
                                            state.userModel!.avatar.toString(),
                                        fit: BoxFit.cover,
                                        height: 80,
                                      ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                cubit.showAddPhotoDialog();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
                              child:
                                  state.userModel!.displayName == null
                                      ? Text(
                                        state.userModel!.username.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      )
                                      : Text(
                                        "${state.userModel!.displayName} ",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                            ),

                            const SizedBox(height: 4),
                            Text(
                              "+856 ${state.userModel!.phoneNumber.toString()}",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 2),
                            Text(
                              "120 ຈຳນວນຖ້ຽວ",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu List
                Expanded(
                  child: ListView(
                    children: [
                      _buildMenuItem(
                        Icons.badge,
                        'ຂໍ້ມູນສ່ວນຕົວ',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PersonalInfoPage(),
                            ),
                          ).then((value) {
                           
                            if (value == true) {
                              context
                                  .read<AuthCubit>()
                                  .getProfile();
                            }
                          });
                        },
                      ),
                      _buildMenuItem(
                        Icons.credit_card_outlined,
                        'ຂໍ້ມູນບັນຊີທະນາຄານ',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BankAccountsPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.shield_outlined,
                        'ຄວາມປອດໄພ',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SecurityInfoPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.language_sharp,
                        'ພາສາລະບົບ',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LanguagePage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.phone_callback,
                        'ປ່ຽນເບີໂທ',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangeNumber(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.rule,
                        'ຂໍ້ກຳນົດ ແລະ ນະໂຍບາຍ',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsPage(),
                            ),
                          );
                        },
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Color(0xFFFECE0C),
                        ),
                        title: const Text(
                          'ອອກຈາກລະບົບ',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        onTap: _showLogoutConfirmation,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    Color iconColor = const Color(0xFFFECE0C),
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
