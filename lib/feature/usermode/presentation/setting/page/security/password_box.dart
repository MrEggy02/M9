import 'package:flutter/material.dart';

class PasswordBox extends StatelessWidget {
  final bool isEditing;
  final bool showOldPassword;
  final bool showNewPassword;
  final bool showConfirmPassword;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback toggleOldPasswordVisibility;
  final VoidCallback toggleNewPasswordVisibility;
  final VoidCallback toggleConfirmPasswordVisibility;
  final GlobalKey<FormState> formKey;
  final VoidCallback onEditTap;

  const PasswordBox({
    super.key,
    required this.isEditing,
    required this.showOldPassword,
    required this.showNewPassword,
    required this.showConfirmPassword,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.toggleOldPasswordVisibility,
    required this.toggleNewPasswordVisibility,
    required this.toggleConfirmPasswordVisibility,
    required this.formKey,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSectionTitle(),
        if (isEditing) ...[
          const SizedBox(height: 8),
          _buildPasswordField(
            icon: Icons.lock_outline,
            hint: 'ລະຫັດຜ່ານເກົ່າ',
            controller: oldPasswordController,
            isPasswordVisible: showOldPassword,
            togglePasswordVisibility: toggleOldPasswordVisibility,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your old password';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          _buildPasswordField(
            icon: Icons.lock,
            hint: 'ລະຫັດຜ່ານໃຫມ່',
            controller: newPasswordController,
            isPasswordVisible: showNewPassword,
            togglePasswordVisibility: toggleNewPasswordVisibility,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a new password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          _buildPasswordField(
            icon: Icons.lock,
            hint: 'ຢືນຢັນລະຫັດຜ່ານໃຫມ່',
            controller: confirmPasswordController,
            isPasswordVisible: showConfirmPassword,
            togglePasswordVisibility: toggleConfirmPasswordVisibility,
            validator: (value) {
              if (value != newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ] else ...[
          _buildPasswordPlaceholder(),
        ],
      ],
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'ລະຫັດຜ່ານ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: onEditTap,
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  size: 16,
                  color: isEditing ? Colors.grey : Colors.blue,
                ),
                const SizedBox(width: 4),
                Text(
                  'ແກ້ໄຂລະຫັດ',
                  style: TextStyle(
                    color: isEditing ? Colors.grey : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    required bool isPasswordVisible,
    required VoidCallback togglePasswordVisibility,
    required String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFECE0C), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800]),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: !isPasswordVisible,
              validator: validator,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                errorStyle: const TextStyle(height: 0),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: togglePasswordVisibility,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordPlaceholder() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFECE0C), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.lock, color: Colors.blue[800]),
          const SizedBox(width: 12),
          const Expanded(
            child: TextField(
              enabled: false,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '********',
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}