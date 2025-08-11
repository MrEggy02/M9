// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:m9/feature/auth/cubit/auth_cubit.dart';
// import 'package:m9/feature/auth/cubit/auth_state.dart';

// class PersonalInfoPage extends StatefulWidget {
//   const PersonalInfoPage({super.key});

//   @override
//   State<PersonalInfoPage> createState() => _PersonalInfoPageState();
// }

// class _PersonalInfoPageState extends State<PersonalInfoPage> {
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _dobController;
//   late String _selectedGender;
//   bool _isEditing = false;
//   bool _isLoading = false;
//   bool _isInitialized = false;

//   // Convert ISO date format to readable format
//   String _formatDate(String? isoDate) {
//     if (isoDate == null || isoDate.isEmpty) return '';
//     try {
//       final date = DateTime.parse(isoDate);
//       return '${date.day}/${date.month}/${date.year}';
//     } catch (e) {
//       return isoDate;
//     }
//   }

//   // Convert date format back to ISO
//   String _parseToIsoDate(String date) {
//     if (date.isEmpty) return '';
//     try {
//       final parts = date.split('/');
//       if (parts.length == 3) {
//         final day = int.tryParse(parts[0]) ?? 1;
//         final month = int.tryParse(parts[1]) ?? 1;
//         final year = int.tryParse(parts[2]) ?? 2000;
//         return DateTime(year, month, day).toIso8601String();
//       }
//       return date;
//     } catch (e) {
//       return date;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     _loadUserData();
//   }

//   void _initializeControllers() {
//     _firstNameController = TextEditingController();
//     _lastNameController = TextEditingController();
//     _dobController = TextEditingController();
//     _selectedGender = 'ຊາຍ'; // Default value
//   }

//   void _loadUserData() {
//     print('🔄 Loading user data...');
//     final authCubit = context.read<AuthCubit>();
//     final state = authCubit.state;

//     // If user data is not available, fetch it
//     if (state.userModel == null) {
//       print('👤 No user model found, fetching profile...');
//       authCubit.getProfile();
//       return;
//     }

//     _updateControllersWithUserData(state.userModel!);
//   }

//   void _updateControllersWithUserData(dynamic user) {
//     print(
//       '📝 Updating controllers with user data: ${user?.firstName} ${user?.lastName}',
//     );

//     setState(() {
//       _firstNameController.text = user?.firstName ?? '';
//       _lastNameController.text = user?.lastName ?? '';
//       _dobController.text = _formatDate(user?.dob);
//       _selectedGender =
//           user?.gender == 'male'
//               ? 'ຊາຍ'
//               : user?.gender == 'female'
//               ? 'ຍິງ'
//               : 'ຊາຍ';
//       _isInitialized = true;
//     });

//     print('✅ Controllers updated successfully');
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _dobController.dispose();
//     super.dispose();
//   }

//   void _toggleEditing() {
//     if (_isEditing) {
//       // Cancel editing - reload original data
//       final state = context.read<AuthCubit>().state;
//       if (state.userModel != null) {
//         _updateControllersWithUserData(state.userModel!);
//       }
//     }
//     setState(() {
//       _isEditing = !_isEditing;
//     });
//   }

//   // Validate form data before saving
//   bool _validateForm() {
//     if (_firstNameController.text.trim().isEmpty) {
//       _showErrorMessage('ກະລຸນາໃສ່ຊື່');
//       return false;
//     }

//     if (_lastNameController.text.trim().isEmpty) {
//       _showErrorMessage('ກະລຸນາໃສ່ນາມສະກຸນ');
//       return false;
//     }

//     return true;
//   }

//   void _showErrorMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   void _showSuccessMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   Future<void> _saveChanges() async {
//     // Validate form first
//     if (!_validateForm()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final firstName = _firstNameController.text.trim();
//       final lastName = _lastNameController.text.trim();

//       print('💾 Saving changes: $firstName $lastName');
//       print('👤 Gender: ${_selectedGender == 'ຊາຍ' ? 'male' : 'female'}');
//       print('🎂 DOB: ${_parseToIsoDate(_dobController.text)}');

//       await context.read<AuthCubit>().editProfile(
//         firstName: firstName,
//         lastName: lastName,
//         phoneNumber: '', // Empty since column doesn't exist
//         email: '', // Empty since column doesn't exist
//         address: '', // Empty since column doesn't exist
//         gender: _selectedGender == 'ຊາຍ' ? 'male' : 'female',
//         dob: _parseToIsoDate(_dobController.text),
//       );

//       // The BlocConsumer will handle the success/error states
//     } catch (e) {
//       print('💥 Save error: $e');
//       _showErrorMessage('ເກີດຂໍ້ຜິດພາດໃນການບັນທຶກ: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate:
//           _dobController.text.isNotEmpty
//               ? DateTime.tryParse(_parseToIsoDate(_dobController.text)) ??
//                   DateTime.now()
//               : DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (picked != null) {
//       setState(() {
//         _dobController.text = _formatDate(picked.toIso8601String());
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 120,
//         leading: Row(
//           children: [
//             const SizedBox(width: 8),
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: () => Navigator.pop(context),
//             ),
//             const Text(
//               'ກັບຄືນ',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         title: const Text(
//           'ຂໍ້ມູນສ່ວນຕົວ',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         actions: [
//           if (!_isLoading && _isInitialized)
//             IconButton(
//               icon: Icon(_isEditing ? Icons.close : Icons.edit),
//               onPressed: _isLoading ? null : _toggleEditing,
//             ),
//         ],
//       ),
//       body: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           // Update controllers when new user data is received
//           if (state.authStatus == AuthStatus.loading &&
//               state.userModel != null &&
//               !_isInitialized) {
//             _updateControllersWithUserData(state.userModel!);
//           }

//           // Handle success state
//           if (state.authStatus == AuthStatus.success && _isEditing) {
//             _showSuccessMessage('ບັນທຶກຂໍ້ມູນສຳເລັດແລ້ວ');
//             setState(() {
//               _isEditing = false;
//             });
//             // Refresh profile data after successful update
//             context.read<AuthCubit>().getProfile();
//           }

//           // Handle error state
//           if (state.authStatus == AuthStatus.failure) {
//             _showErrorMessage(
//               'ເກີດຂໍ້ຜິດພາດ: ${state.error ?? "Unknown error"}',
//             );
//           }
//         },
//         builder: (context, state) {
//           // Show loading spinner while fetching initial data
//           if (state.authStatus == AuthStatus.loading && !_isInitialized) {
//             return const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('กำลังโหลดข้อมูลผู้ใช้...'),
//                 ],
//               ),
//             );
//           }

//           // Show error message if failed to load
//           if (state.authStatus == AuthStatus.failure && !_isInitialized) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     'ไม่สามารถโหลดข้อมูลได้\n${state.error ?? "Unknown error"}',
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => context.read<AuthCubit>().getProfile(),
//                     child: const Text('ลองใหม่'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           // Show main content
//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'ຂໍ້ມູນທົ່ວໄປ',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                 ),
//                 const SizedBox(height: 8),

//                 // Form fields - Only the fields that exist in your database
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         // First Name field
//                         _buildEditableField(
//                           Icons.person_pin_rounded,
//                           'ຊື່',
//                           _firstNameController,
//                         ),
//                         // Last Name field
//                         _buildEditableField(
//                           Icons.person_pin_rounded,
//                           'ນາມສະກຸນ',
//                           _lastNameController,
//                         ),
//                         _buildDateField(),
//                         const SizedBox(height: 16),
//                         const Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'ເພດ',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         _buildGenderField(),
//                         const SizedBox(height: 32),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Save button - Always visible when editing
//                 if (_isEditing)
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFFECE0C),
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 2,
//                       ),
//                       onPressed: _isLoading ? null : _saveChanges,
//                       child:
//                           _isLoading
//                               ? const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.black,
//                                       strokeWidth: 2,
//                                     ),
//                                   ),
//                                   SizedBox(width: 12),
//                                   Text(
//                                     'ກຳລັງບັນທຶກ...',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                               : const Text(
//                                 'ບັນທຶກການປ່ຽນແປງ',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Editable field for name only
//   Widget _buildEditableField(
//     IconData icon,
//     String label,
//     TextEditingController controller,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFFFECE0C), width: 2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blue[800]),
//           const SizedBox(width: 12),
//           Expanded(
//             child:
//                 _isEditing
//                     ? TextField(
//                       controller: controller,
//                       decoration: InputDecoration(
//                         hintText: label,
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.zero,
//                       ),
//                       style: const TextStyle(fontSize: 16),
//                       keyboardType: TextInputType.text,
//                     )
//                     : Text(
//                       controller.text.isNotEmpty
//                           ? controller.text
//                           : 'ບໍ່ມີຂໍ້ມູນ',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color:
//                             controller.text.isEmpty
//                                 ? Colors.grey
//                                 : Colors.black,
//                       ),
//                     ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateField() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFFFECE0C), width: 2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.calendar_month_outlined, color: Colors.blue[800]),
//           const SizedBox(width: 12),
//           Expanded(
//             child:
//                 _isEditing
//                     ? GestureDetector(
//                       onTap: _selectDate,
//                       child: AbsorbPointer(
//                         child: TextField(
//                           controller: _dobController,
//                           decoration: const InputDecoration(
//                             hintText: 'ວັນເກີດ',
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     )
//                     : Text(
//                       _dobController.text.isNotEmpty
//                           ? _dobController.text
//                           : 'ບໍ່ມີຂໍ້ມູນ',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color:
//                             _dobController.text.isEmpty
//                                 ? Colors.grey
//                                 : Colors.black,
//                       ),
//                     ),
//           ),
//           if (_isEditing)
//             Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
//         ],
//       ),
//     );
//   }

//   Widget _buildGenderField() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFFFECE0C), width: 2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.wc, color: Colors.blue[800]),
//           const SizedBox(width: 12),
//           Expanded(
//             child:
//                 _isEditing
//                     ? DropdownButton<String>(
//                       value: _selectedGender,
//                       isExpanded: true,
//                       underline: const SizedBox(),
//                       items:
//                           <String>['ຊາຍ', 'ຍິງ'].map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _selectedGender = newValue!;
//                         });
//                       },
//                     )
//                     : Text(
//                       _selectedGender,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//           ),
//         ],
//       ),
//     );
//   }
// }
