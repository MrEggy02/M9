// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:m9/feature/auth/cubit/auth_cubit.dart';
// import 'package:m9/feature/auth/domain/models/bank_account_model.dart';

// class BankAccountPage extends StatefulWidget {
//   final BankAccount? editBankAccount;

//   const BankAccountPage({super.key, this.editBankAccount});

//   @override
//   State<BankAccountPage> createState() => _BankAccountPageState();
// }

// class _BankAccountPageState extends State<BankAccountPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _getFullImageUrl(String? relativePath) {
//     if (relativePath == null) return '';
//     if (relativePath.startsWith('http')) return relativePath;
//     return 'https://m9-driver-api.onrender.com/$relativePath';
//   }

//   final List<String> _banks = [
//     'Bcel',
//     'LDB',
//     'APB',
//     'JDB',
//     'ທະນາຄານແຫ່ງ ສປປ ລາວ',
//     'ທະນາຄານກະສິກຳ',
//     'ທະນາຄານພັດທະນາ',
//   ];

//   // Add flag to track if we're performing save operation
//   bool _isSaving = false;
//   String? _selectedBank;
//   File? _selectedImage;

//   @override
//   void initState() {
//     super.initState();
//     context.read<AuthCubit>().getBankAccounts();

//     if (widget.editBankAccount != null) {
//       // Initialize controllers immediately with edit data
//       final authCubit = context.read<AuthCubit>();
//       authCubit.setBankAccountForEdit(widget.editBankAccount!);

//       // Set the selected bank after controllers are initialized
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           _selectedBank = _findMatchingBank(authCubit.bankNameController.text);
//         });
//       });
//     }
//   }

//   // Helper method to find matching bank name
//   String? _findMatchingBank(String bankName) {
//     // Try exact match first
//     if (_banks.contains(bankName)) {
//       return bankName;
//     }

//     // Try case-insensitive match
//     for (String bank in _banks) {
//       if (bank.toLowerCase() == bankName.toLowerCase()) {
//         return bank;
//       }
//     }

//     // Try partial match for common variations
//     String lowerBankName = bankName.toLowerCase();
//     for (String bank in _banks) {
//       String lowerBank = bank.toLowerCase();
//       if (lowerBank.contains(lowerBankName) ||
//           lowerBankName.contains(lowerBank)) {
//         return bank;
//       }
//     }

//     // If no match found, add the bank name to the list and return it
//     print('⚠ Bank "$bankName" not found in predefined list, adding it');
//     _banks.add(bankName);
//     return bankName;
//   }

//   InputDecoration _inputDecoration({
//     required String labelText,
//     required Icon prefixIcon,
//   }) {
//     return InputDecoration(
//       labelText: labelText,
//       prefixIcon: prefixIcon,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       enabledBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Color(0xFFFECE0C), width: 2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Color(0xFFFECE0C), width: 2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//     );
//   }

//   Future<void> _pickImage() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 800,
//         maxHeight: 800,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         // Verify the file exists and is readable
//         if (await file.exists()) {
//           setState(() {
//             _selectedImage = file;
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Could not read the selected image')),
//           );
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error selecting image: ${e.toString()}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leadingWidth: 120,
//         leading: Row(
//           children: [
//             const SizedBox(width: 8),
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: () =>
//                   Navigator.pop(context, false), // Return false when cancelled
//             ),
//             const Text(
//               'ກັບຄືນ',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         title: Text(
//           widget.editBankAccount == null
//               ? 'ເພີ່ມບັນຊີທະນາຄານ'
//               : 'ແກ້ໄຂບັນຊີທະນາຄານ',
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           // Only handle success/failure when we're actually saving
//           if (_isSaving) {
//             if (state.authStatus == AuthStatus.failure) {
//               setState(() {
//                 _isSaving = false; // Reset flag
//               });
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.error ?? 'ເກີດຂໍ້ຜິດພາດ'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             } else if (state.authStatus == AuthStatus.success) {
//               setState(() {
//                 _isSaving = false; // Reset flag
//               });

//               // Return true to indicate successful save
//               Navigator.pop(context, true);
//             }
//           }
//         },
//         builder: (context, state) {
//           final authCubit = context.read<AuthCubit>();
//           final isEditing = widget.editBankAccount != null;

//           // Show loading only when initially loading and no data exists
//           if (state.authStatus == AuthStatus.loading &&
//               state.bankAccounts.isEmpty &&
//               !_isSaving) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // Show error only when loading fails and no data exists
//           if (state.authStatus == AuthStatus.failure &&
//               state.bankAccounts.isEmpty &&
//               !_isSaving) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ'),
//                   ElevatedButton(
//                     onPressed: () => authCubit.getBankAccounts(),
//                     child: const Text('ລອງໃໝ່'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'ກະລຸນາໃສ່ຂໍ້ມູນບັນຊີທະນາຄານຂອງທ່ານ',
//                           style: TextStyle(fontSize: 16, color: Colors.black54),
//                         ),
//                         const SizedBox(height: 20),

//                         // Bank Selection Dropdown
//                         FormField<String>(
//                           initialValue: _selectedBank,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'ກະລຸນາເລືອກທະນາຄານ';
//                             }
//                             return null;
//                           },
//                           builder: (FormFieldState<String> field) {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: field.hasError
//                                           ? Colors.red
//                                           : const Color(0xFFFECE0C),
//                                       width: 2,
//                                     ),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: DropdownButton<String>(
//                                     value: _selectedBank,
//                                     hint: const Padding(
//                                       padding: EdgeInsets.only(left: 12),
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             Icons.account_balance,
//                                             color: Color(0xFFFECE0C),
//                                           ),
//                                           SizedBox(width: 12),
//                                           Text('ເລືອກທະນາຄານ'),
//                                         ],
//                                       ),
//                                     ),
//                                     isExpanded: true,
//                                     underline: const SizedBox(),
//                                     items: _banks.map((bank) {
//                                       return DropdownMenuItem<String>(
//                                         value: bank,
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 16,
//                                           ),
//                                           child: Row(
//                                             children: [
//                                               const Icon(
//                                                 Icons.account_balance,
//                                                 color: Color(0xFFFECE0C),
//                                               ),
//                                               const SizedBox(width: 12),
//                                               Expanded(child: Text(bank)),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     }).toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _selectedBank = value;
//                                       });
//                                       context
//                                               .read<AuthCubit>()
//                                               .bankNameController
//                                               .text =
//                                           value ?? '';
//                                     },
//                                   ),
//                                 ),
//                                 if (field.hasError)
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                       top: 5,
//                                       left: 12,
//                                     ),
//                                     child: Text(
//                                       field.errorText!,
//                                       style: const TextStyle(
//                                         color: Colors.red,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                                 if (_selectedBank != null &&
//                                     !_banks.contains(_selectedBank))
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                       top: 5,
//                                       left: 12,
//                                     ),
//                                     child: Text(
//                                       'ປັດຈຸບັນ: $_selectedBank',
//                                       style: const TextStyle(
//                                         color: Colors.orange,
//                                         fontSize: 12,
//                                         fontStyle: FontStyle.italic,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 15),

//                         // Account Name Field
//                         TextFormField(
//                           controller: authCubit.accountNameController,
//                           decoration: _inputDecoration(
//                             labelText: 'ຊື່ເຈົ້າຂອງບັນຊີ',
//                             prefixIcon: const Icon(Icons.person),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'ກະລຸນາໃສ່ຊື່ເຈົ້າຂອງບັນຊີ';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),

//                         // Account Number Field
//                         TextFormField(
//                           controller: authCubit.accountNoController,
//                           keyboardType: TextInputType.number,
//                           decoration: _inputDecoration(
//                             labelText: 'ເລກບັນຊີ',
//                             prefixIcon: const Icon(Icons.numbers),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'ກະລຸນາໃສ່ເລກບັນຊີ';
//                             }
//                             if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//                               return 'ເລກບັນຊີຕ້ອງເປັນຕົວເລກເທົ່ານັ້ນ';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),

//                         // Image Upload Section
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'ຮູບພາບຂອງບັດ (ບໍ່ບັງຄັບ)',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             GestureDetector(
//                               onTap: _pickImage,
//                               child: // In your BankAccountPage build method
//                               Container(
//                                 height: 120,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: const Color(0xFFFECE0C),
//                                     width: 2,
//                                   ),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: _selectedImage != null
//                                     ? ClipRRect(
//                                         borderRadius: BorderRadius.circular(6),
//                                         child: Image.file(
//                                           _selectedImage!,
//                                           width: double.infinity,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       )
//                                     : widget.editBankAccount?.image != null
//                                     ? ClipRRect(
//                                         borderRadius: BorderRadius.circular(6),
//                                         child: Image.network(
//                                           _getFullImageUrl(
//                                             widget.editBankAccount!.image,
//                                           ),
//                                           width: double.infinity,
//                                           fit: BoxFit.cover,
//                                           errorBuilder:
//                                               (context, error, stackTrace) {
//                                                 return Container(
//                                                   color: Colors.grey[200],
//                                                   child: const Center(
//                                                     child: Icon(
//                                                       Icons.account_balance,
//                                                       color: Color(0xFFFECE0C),
//                                                       size: 40,
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                           loadingBuilder: (context, child, loadingProgress) {
//                                             if (loadingProgress == null)
//                                               return child;
//                                             return Center(
//                                               child: CircularProgressIndicator(
//                                                 value:
//                                                     loadingProgress
//                                                             .expectedTotalBytes !=
//                                                         null
//                                                     ? loadingProgress
//                                                               .cumulativeBytesLoaded /
//                                                           loadingProgress
//                                                               .expectedTotalBytes!
//                                                     : null,
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       )
//                                     : const Center(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Icon(
//                                               Icons.add_photo_alternate,
//                                               color: Color(0xFFFECE0C),
//                                               size: 40,
//                                             ),
//                                             Text('ເພີ່ມຮູບພາບ'),
//                                           ],
//                                         ),
//                                       ),
//                               ),
//                             ),

//                             // Debug info (remove in production)
//                             if (isEditing) ...[
//                               const SizedBox(height: 20),
//                               Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade100,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Debug Info:',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       'ID: ${authCubit.bankIdController.text}',
//                                     ),
//                                     Text(
//                                       'Bank: ${authCubit.bankNameController.text}',
//                                     ),
//                                     Text(
//                                       'Account Name: ${authCubit.accountNameController.text}',
//                                     ),
//                                     Text(
//                                       'Account No: ${authCubit.accountNoController.text}',
//                                     ),
//                                     Text('Selected Bank: $_selectedBank'),
//                                     if (_selectedImage != null)
//                                       Text(
//                                         'Image Path: ${_selectedImage!.path}',
//                                       ),
//                                     if (widget.editBankAccount?.image != null)
//                                       Text(
//                                         'Existing Image: ${widget.editBankAccount!.image}',
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               // Save Button
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed:
//                         (_isSaving || state.authStatus == AuthStatus.loading)
//                         ? null
//                         : () async {
//                             // In the save button onPressed:
//                             if (_formKey.currentState!.validate()) {
//                               final authCubit = context.read<AuthCubit>();
//                               setState(() => _isSaving = true);

//                               try {
//                                 if (widget.editBankAccount != null) {
//                                   await authCubit.editBankAccount(
//                                     image: _selectedImage != null
//                                         ? _selectedImage!.path
//                                         : widget.editBankAccount!.image,
//                                   );
//                                 } else {
//                                   await authCubit.addBankAccount(
//                                     image: _selectedImage!,
//                                   );
//                                 }
//                                 // If we get here, it was successful
//                                 Navigator.pop(context, true); // Add this line
//                               } catch (e) {
//                                 setState(() => _isSaving = false);
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       'ເກີດຂໍ້ຜິດພາດ: ${e.toString()}',
//                                     ),
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFECE0C),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: _isSaving
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.black,
//                               ),
//                             ),
//                           )
//                         : Text(
//                             isEditing ? 'ອັບເດດຂໍ້ມູນ' : 'ບັນທຶກຂໍ້ມູນ',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
