import 'package:flutter/material.dart';

class SecurityInfoPage extends StatefulWidget {
  const SecurityInfoPage({super.key});

  @override
  State<SecurityInfoPage> createState() => _SecurityInfoPageState();
}

class _SecurityInfoPageState extends State<SecurityInfoPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        leading: Row(
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
        title: const Text(
          'ຄວາມປອດໄພ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionTitle('ເບີໂທ', 'ແກ້ໄຂເບີໂທ', onTap: () {
              // Handle phone edit
            }),
            _buildEditableField(Icons.phone, 'ຫມາຍເລກໂທລະສັບ', _phoneController),

            const SizedBox(height: 24),
            _buildSectionTitle('ລະຫັດຜ່ານ', 'ແກ້ໄຂລະຫັດ', onTap: () {
              // Handle password edit
            }),
            _buildEditableField(Icons.lock, 'ລະຫັດຜ່ານ', _passwordController, obscureText: true),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
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
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  print('Phone: ${_phoneController.text}');
                  print('Password: ${_passwordController.text}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String actionText, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                const Icon(Icons.edit, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  actionText,
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEditableField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
