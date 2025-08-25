import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/core/config/theme/app_color.dart';
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
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfileData();
  }

  void _initializeControllers() {
    _usernameController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
  }

  Future<void> _loadProfileData() async {
    await context.read<AuthCubit>().getProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        final cubit = context.read<AuthCubit>();

        if (state.authStatus == AuthStatus.failure) {
          _isUpdating = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? 'Error occurred')),
          );
        }

        if (state.authStatus == AuthStatus.success) {
          if (state.userModel != null) {
            final user = state.userModel!;
            _usernameController.text = user.username ?? '';
            _firstNameController.text = user.firstName ?? '';
            _lastNameController.text = user.lastName ?? '';
            _emailController.text = user.email ?? '';
            _addressController.text = user.address ?? '';
            cubit.selectedGender = user.gender;
            cubit.dobController.text = user.dob ?? '';
          }
          
          // Hide loading state whether it's from initial load or update
          _isUpdating = false;
          
  

          
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();

        return Scaffold(
          bottomNavigationBar: Container(
            height: 120,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
                  child: GestureDetector(
                    onTap: _isUpdating 
                        ? null 
                        : () async {
                            setState(() => _isUpdating = true);
                            await cubit.updateUser(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              dob: cubit.dobController.text,
                              username: _usernameController.text,
                              email: _emailController.text,
                              address: _addressController.text,
                              gender: cubit.selectedGender ?? '',
                            );
                            Navigator.pop(context, true);
                          },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: _isUpdating 
                            ? AppColors.primaryColor.withOpacity(0.5)
                            : AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isUpdating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "ບັນທຶກການປ່ຽນແປງ",
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
        leadingWidth: 120,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'ກັບຄືນ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
        title: const Text(
          'ຂໍ້ມູນສ່ວນຕົວ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AuthState state) {
    if (state.authStatus == AuthStatus.loading && state.userModel == null) {
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

    final cubit = context.read<AuthCubit>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ຂໍ້ມູນທົ່ວໄປ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  TxtPersonalWidget(
                    controller: _usernameController,
                    icon: Icons.badge_rounded,
                    name: "ຊື່ຜູ້ໃຊ້",
                    type: TextInputType.text,
                  ),
                  const SizedBox(height: 15),
                  TxtPersonalWidget(
                    controller: _firstNameController,
                    icon: Icons.badge_rounded,
                    name: "ຊື່",
                    type: TextInputType.text,
                  ),
                  const SizedBox(height: 15),
                  TxtPersonalWidget(
                    controller: _lastNameController,
                    icon: Icons.badge_rounded,
                    name: "ນາມສະກຸນ",
                    type: TextInputType.text,
                  ),
                  const SizedBox(height: 15),
                  TxtPersonalWidget(
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    name: "ອີເມວ",
                    type: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  DatePersonalWidget(controller: cubit.dobController),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ເພດ/ທີ່ຢູ່',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GenderPersonalWidget(
                    initialGender: cubit.selectedGender,
                    onChanged: (value) {
                      cubit.selectedGender = value;
                    },
                  ),
                  const SizedBox(height: 15),
                  TxtPersonalWidget(
                    controller: _addressController,
                    icon: Icons.pin_drop_sharp,
                    name: "ບ້ານເມືອງແຂວງ",
                    type: TextInputType.text,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
