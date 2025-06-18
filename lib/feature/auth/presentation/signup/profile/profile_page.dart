import 'package:flutter/material.dart';

// ໜ້າບັນທຶກຂໍ້ມູນຜູ້ໃຊ້
class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  // ຕົວຄວບຄຸມຂໍ້ມູນຕ່າງໆ
  final TextEditingController _nameController = TextEditingController();

  // ຕົວປ່ຽນຄວບຄຸມສະຖານະການປ້ອນຂໍ້ມູນ
  bool _isInfoComplete = false;

  @override
  void initState() {
    super.initState();
    // ຟັງຊັນຟັງຫຼັງຈາກປ້ອນຂໍ້ມູນ
    _nameController.addListener(_validateInfo);
  }

  // ກວດສອບຄວາມຖືກຕ້ອງຂອງຂໍ້ມູນ
  void _validateInfo() {
    setState(() {
      // ກວດສອບຊື່
      _isInfoComplete = _nameController.text.isNotEmpty;
    });
  }

  // ໄປຫາໜ້າຖັດໄປ
  void _navigateToNextScreen() {
    if (_isInfoComplete) {
      // ສາມາດໄປໜ້າຖັດໄປຫຼືເຮັດຫຍັງຕໍ່ກໍໄດ້
      Navigator.of(context).pushNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('ຈຳນວນຜູ້ໃຫ້ໃໝ່'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ປ້ອນຂໍ້ມູນສ່ວນຕົວ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'ຊື່',
                hintText: 'ປ້ອນຊື່ຂອງທ່ານ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isInfoComplete ? _navigateToNextScreen : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isInfoComplete 
                  ? Colors.yellow 
                  : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'ສືບຕໍ່',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}