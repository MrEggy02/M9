import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguage = 'lo';

  final List<Map<String, dynamic>> _languages = [
    {
      'code': 'lo',
      'name': 'ລາວ (Lao)',
      'native': 'ພາສາລາວ',
      'flag': 'images/lao.png',
    },
    {
      'code': 'en',
      'name': 'English',
      'native': 'English',
      'flag': 'images/en.png',
    },
    {
      'code': 'zh',
      'name': '中文 (Chinese)',
      'native': '中文',
      'flag': 'images/ch.png',
    },
    {
      'code': 'ko',
      'name': '한국어 (Korean)',
      'native': '한국어',
      'flag': 'images/ko.png',
    },
  ];

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
          'ພາສາລະບົບ',
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ເລືອກພາສາທີ່ທ່ານຕ້ອງການ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: _languages.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                final language = _languages[index];
                return _buildLanguageTile(
                  languageCode: language['code'],
                  languageName: language['name'],
                  nativeName: language['native'],
                  flagAsset: language['flag'],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Save language preference
                Navigator.pop(context, _selectedLanguage);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFECE0C),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'ຢືນຢັນ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile({
    required String languageCode,
    required String languageName,
    required String nativeName,
    required String flagAsset,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: ClipOval(
          child: Image.asset(flagAsset, fit: BoxFit.cover),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            nativeName,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: Radio<String>(
        value: languageCode,
        groupValue: _selectedLanguage,
        onChanged: (value) {
          setState(() {
            _selectedLanguage = value!;
          });
        },
        activeColor: const Color(0xFFFECE0C),
      ),
      onTap: () {
        setState(() {
          _selectedLanguage = languageCode;
        });
      },
    );
  }
}