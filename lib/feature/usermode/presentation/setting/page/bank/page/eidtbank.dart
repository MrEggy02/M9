import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:m9/feature/auth/cubit/auth_cubit.dart';
import 'package:m9/feature/auth/domain/models/bank_account_model.dart';
import 'package:m9/feature/usermode/presentation/setting/page/bank/widget/editimage.dart';
import 'package:m9/feature/usermode/presentation/setting/page/bank/widget/edittxt.dart';

class EditBankAccountPage extends StatefulWidget {
  final BankAccount account;

  const EditBankAccountPage({super.key, required this.account});

  @override
  State<EditBankAccountPage> createState() => _EditBankAccountPageState();
}

class _EditBankAccountPageState extends State<EditBankAccountPage> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  XFile? _selectedImage;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ເກີດຂໍ້ຜິດພາດໃນການເລືອກຮູບ: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ເລືອກທີ່ມາຂອງຮູບພາບ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('ກ້ອງຖ່າຍຮູບ'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('ຄັງຮູບພາບ'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessMessage() {
    SuccessWidget.show(
      context: context,
      title: 'ແກ້ໄຂຂໍ້ມູນສຳເລັດ',
      subtitle: 'ຂໍ້ມູນບັນຊີທະນາຄານຂອງທ່ານໄດ້ຖືກອັບເດດແລ້ວ',
      duration: const Duration(seconds: 2),
      onComplete: () {
        if (mounted) {
          Navigator.pop(context, true);
        }
      },
    );
  }

  // Submit with proper image handling
  Future<void> _submit(
    TextEditingController bankNameController,
    TextEditingController accountNameController,
    TextEditingController accountNoController,
  ) async {
    if (bankNameController.text.isEmpty ||
        accountNameController.text.isEmpty ||
        accountNoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ກະລຸນາປ້ອນຂໍ້ມູນໃຫ້ຄົບຖ້ວນ')),
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
            Text('ກຳລັງອັບເດດຂໍ້ມູນ...'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      String? finalImagePath;
      
      // If there's a new image, upload it first
      if (_selectedImage != null) {
        setState(() { _isUploadingImage = true; });
        final imageFile = File(_selectedImage!.path);
        finalImagePath = await EditBankAccountWidget.uploadImageToServer(
          context,
          imageFile,
          widget.account,
        );
        
        if (finalImagePath == null) {
          throw Exception('Image upload failed');
        }
        setState(() { _isUploadingImage = false; });
      } else {
        // Use existing image path if no new image selected
        finalImagePath = widget.account.image;
      }
      
      // Create updated account with the new image path
      final updatedAccount = BankAccount(
        id: widget.account.id,
        bankName: bankNameController.text.trim(),
        accountName: accountNameController.text.trim(),
        accountNo: accountNoController.text.trim(),
        isActive: widget.account.isActive,
        image: finalImagePath,
        userId: widget.account.userId,
        createdAt: widget.account.createdAt,
      );
      
      // Only call updateBankAccount if no image was uploaded (to avoid double update)
      if (_selectedImage == null) {
        await context.read<AuthCubit>().updateBankAccount(updatedAccount);
      }
      
      if (mounted) {
        scaffold.hideCurrentSnackBar();
        _showSuccessMessage();
      }
    } catch (e) {
      setState(() { _isUploadingImage = false; });
      if (mounted) {
        scaffold.hideCurrentSnackBar();
        scaffold.showSnackBar(
          SnackBar(
            content: Text('ອັບເດດລົ້ມເຫຼວ: ${e.toString()}'),
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
          'ແກ້ໄຂບັນຊີທະນາຄານ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: EditBankAccountWidget(
          account: widget.account,
          selectedImage: _selectedImage,
          isUploadingImage: _isUploadingImage,
          onPickImage: _showImageSourceDialog,
          onSubmit: _submit,
        ),
      ),
    );
  }
}
