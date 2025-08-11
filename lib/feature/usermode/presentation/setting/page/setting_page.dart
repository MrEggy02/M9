import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';

import 'package:m9/feature/auth/cubit/auth_state.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
                        final authCubit = context.read<AuthCubit>();
                        //   authCubit.deleteAll(); // Clear local data
                        Navigator.pop(context); // Close dialog
                        // Navigate to login page or handle logout logic
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ການຕັ້ງຄ່າ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.menu, color: Colors.black),
          ),
          onPressed: () {},
        ),
        /*  actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProfileData,
          ),
        ],*/
      ),
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

          final user = state.userModel;

          // Updated display name logic - prioritize firstName + lastName
          String displayName = 'ບໍ່ມີຂໍ້ມູນ';
          if (user?.firstName != null && user!.firstName!.isNotEmpty) {
            final firstName = user.firstName!;
            final lastName = user.lastName ?? '';
            displayName = '$firstName $lastName'.trim();
          } else if (user?.displayName != null &&
              user!.displayName!.isNotEmpty) {
            displayName = user.displayName!;
          } else if (user?.username != null && user!.username!.isNotEmpty) {
            displayName = user.username!;
          }

          final phoneNumber = user?.phoneNumber ?? 'ບໍ່ມີເບີໂທ';

          return RefreshIndicator(
            onRefresh: () async {
              //  _loadProfileData();
            },
            color: const Color(0xFFFECE0C),
            child: Column(
              children: [
                // Profile Card with Gradient
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
                                  _profileImage != null
                                      ? Image.file(
                                        _profileImage!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Image.asset(
                                            'assets/images/image.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                      : (user?.avatar != null &&
                                          user!.avatar!.isNotEmpty)
                                      ? Image.network(
                                        user.avatar!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Image.asset(
                                            'assets/images/image.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                      : Image.asset(
                                        'assets/images/image.png',
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                          //    onTap: _showAddPhotoDialog,
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
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phoneNumber,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            if (user?.email != null &&
                                user!.email!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                user.email!,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const PersonalInfoPage(),
                          //   ),
                          // );
                        },
                      ),
                      _buildMenuItem(
                        Icons.credit_card_outlined,
                        'ຂໍ້ມູນບັນຊີທະນາຄານ',
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder:
                          //         (context) => const BankAccountsListPage(),
                          //   ),
                          // ).then(
                          //   (_) => _loadProfileData(),
                          // ); // Refresh data when returning
                        },
                      ),
                      _buildMenuItem(
                        Icons.shield_moon,
                        'ຄວາມປອດໄພ',
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const SecurityInfoPage(),
                          //   ),
                          // );
                        },
                      ),
                      _buildMenuItem(
                        Icons.language_sharp,
                        'ພາສາລະບົບ',
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const LanguagePage(),
                          //   ),
                          // );
                        },
                      ),
                      _buildMenuItem(
                        Icons.phone_callback,
                        'ປ່ຽນເບີໂທ',
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const ChangeNumberPage(),
                          //   ),
                          // );
                        },
                      ),
                      _buildMenuItem(
                        Icons.rule,
                        'ຂໍ້ກຳນົດ ແລະ ນະໂຍບາຍ',
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const TermsPage(),
                          //   ),
                          // );
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
