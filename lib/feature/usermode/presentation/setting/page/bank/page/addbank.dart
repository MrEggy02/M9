import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/usermode/presentation/setting/page/bank/widget/addfrom.dart' hide ImagePicker;

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({super.key});

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bankNameController;
  late final TextEditingController _accountNameController;
  late final TextEditingController _accountNoController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _bankNameController = TextEditingController();
    _accountNameController = TextEditingController();
    _accountNoController = TextEditingController();
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ກະລຸນາເລືອກຮູບພາບ')),
      );
      return;
    }

    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('ກຳລັງເພີ່ມບັນຊີທະນາຄານ...'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      await context.read<AuthCubit>().addBankAccount(
        bankName: _bankNameController.text.trim(),
        accountName: _accountNameController.text.trim(),
        accountNo: _accountNoController.text.trim(),
        image: _selectedImage!,
      );

      if (mounted) {
        scaffold.hideCurrentSnackBar();
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        scaffold.hideCurrentSnackBar();
        scaffold.showSnackBar(
          SnackBar(
            content: Text('ເພີ່ມບັນຊີລົ້ມເຫຼວ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
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
          'ເພີ່ມບັນຊີທະນາຄານໃໝ່',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: AddBankForm(
          formKey: _formKey,
          bankNameController: _bankNameController,
          accountNameController: _accountNameController,
          accountNoController: _accountNoController,
          selectedImage: _selectedImage,
          onImagePick: _pickImage,
          onSubmit: _submit,
        ),
      ),
    );
  }
}