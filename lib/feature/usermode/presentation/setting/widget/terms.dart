import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        title: const Text(
          'ຂໍ້ກຳນົດ ແລະ ນະໂຍບາຍ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ຂໍ້ກຳນົດແລະເງື່ອນໄຂການໃຊ້ງານ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('1. ການຍອມຮັບຂໍ້ກຳນົດ'),
                  _buildSectionContent(
                      'ການໃຊ້ງານແອັບພລິເຄຊັນນີ້ ໝາຍຄວາມວ່າທ່ານໄດ້ຍອມຮັບຕາມຂໍ້ກຳນົດແລະເງື່ອນໄຂທັງໝົດທີ່ກຳນົດໄວ້ໃນຫນ້ານີ້.'),
                  
                  _buildSectionTitle('2. ການໃຊ້ງານ'),
                  _buildSectionContent(
                      'ແອັບພລິເຄຊັນນີ້ສະໜອງບໍລິການ... [ເພີ່ມເນື້ອໃນຕາມຄວາມເໝາະສົມ]'),
                  
                  _buildSectionTitle('3. ຄວາມຮັບຜິດຊອບ'),
                  _buildSectionContent(
                      'ພວກເຮົາຈະບໍ່ຮັບຜິດຊອບຕໍ່ການໃຊ້ງານທີ່ບໍ່ຖືກຕ້ອງ ຫຼື ການນຳໃຊ້ແອັບພລິເຄຊັນໃນທາງທີ່ຜິດກົດໝາຍ.'),
                  
                  _buildSectionTitle('4. ການປ່ຽນແປງ'),
                  _buildSectionContent(
                      'ພວກເຮົາສະຫງວນສິດໃນການແກ້ໄຂຂໍ້ກຳນົດແລະເງື່ອນໄຂໃນທຸກເວລາໂດຍບໍ່ຕ້ອງແຈ້ງໃຫ້ທ່ານຮູ້ລ່ວງຫນ້າ.'),
                ],
              ),
            ),
          ),
          // Button at the bottom
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFECE0C),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'ຂ້ອຍເຂົ້າໃຈແລ້ວ',
                  style: TextStyle(
                    fontSize: 16,
                    
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0C697A),
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }
}