import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/cubit/auth_state.dart';
import 'package:m9/feature/usermode/presentation/setting/page/security/widget/password_box.dart';


class SecurityInfoPage extends StatefulWidget {
  const SecurityInfoPage({super.key});

  @override
  State<SecurityInfoPage> createState() => _SecurityInfoPageState();
}

class _SecurityInfoPageState extends State<SecurityInfoPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEditingPassword = false;
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'ຄວາມປອດໄພ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.authStatus == AuthStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully!')),
            );
            setState(() {
              _isEditingPassword = false;
              _oldPasswordController.clear();
              _newPasswordController.clear();
              _confirmPasswordController.clear();
            });
          } else if (state.authStatus == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Failed to change password')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                PasswordBox(
                  isEditing: _isEditingPassword,
                  showOldPassword: _showOldPassword,
                  showNewPassword: _showNewPassword,
                  showConfirmPassword: _showConfirmPassword,
                  oldPasswordController: _oldPasswordController,
                  newPasswordController: _newPasswordController,
                  confirmPasswordController: _confirmPasswordController,
                  toggleOldPasswordVisibility: () {
                    setState(() {
                      _showOldPassword = !_showOldPassword;
                    });
                  },
                  toggleNewPasswordVisibility: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                  toggleConfirmPasswordVisibility: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                  formKey: _formKey,
                  onEditTap: () {
                    setState(() {
                      _isEditingPassword = !_isEditingPassword;
                    });
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state.authStatus == AuthStatus.loading) {
                          return const ElevatedButton(
                            onPressed: null,
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFECE0C),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.save, color: Colors.black),
                          label: const Text(
                            'ບັນທຶກ',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (_isEditingPassword) {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().ChangePassword(
                                  oldPassword: _oldPasswordController.text,
                                  password: _newPasswordController.text,
                                  confirmPassword: _confirmPasswordController.text,
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
