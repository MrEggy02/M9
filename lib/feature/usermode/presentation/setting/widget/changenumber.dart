// import 'package:flutter/material.dart';
// import 'package:m9/feature/auth/presentation/signup/otp/page/otp_verify.dart';


// class ChangeNumberPage extends StatefulWidget {
//   const ChangeNumberPage({super.key});

//   @override
//   State<ChangeNumberPage> createState() => _ChangeNumberPageState();
// }

// class _ChangeNumberPageState extends State<ChangeNumberPage> {
//   final TextEditingController _phoneController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//         appBar: AppBar(
//   centerTitle: true, // ✅ This forces the title to center properly
//   leadingWidth: 120,
//   leading: Row(
//     children: [
//       const SizedBox(width: 8),
//       IconButton(
//         icon: const Icon(Icons.arrow_back_ios),
//         onPressed: () => Navigator.pop(context),
//       ),
//       const Text(
//         'ກັບຄືນ',
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//       ),
//     ],
//   ),
//   title: const Text(
//     'ປ່ຽນເບີໂທ',
//     style: TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.bold,
//     ),
//   ),
// ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'ເບີໂທລະສັບໃໝ່',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _phoneController,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       prefixIcon: Container(
//                         margin: const EdgeInsets.all(8),
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFFECE0C),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(Icons.phone_android, color: Colors.black),
//                       ),
//                       prefixText: '+856 20 ',
//                       hintText: 'ປ້ອນເບີໂທລະສັບ',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       contentPadding:
//                           const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'ປ້ອນໝາຍເລກໂທລະສັບໃໝ່ເພື່ອຮັບລະຫັດ OTP ໃນການຢືນຢັນເບີໂທຂອງທ່ານ',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFFECE0C),
//                     foregroundColor: Colors.black,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   onPressed: () {
//                    Navigator.push(
//                        context,
//                             MaterialPageRoute(
//                   builder: (context) => OtpVerificationPage(
//                              phoneNumber: '+856 20 ${_phoneController.text}',
//                                         ),
//                           ),
//                     );
//                    },
//                   child: const Text(
//                     'ຕໍ່ໄປ',
//                   style: TextStyle(
//                     fontSize: 16,
//                    ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
