// import 'package:flutter/material.dart';
// import '../../domain/models/banner.dart';

// class SliderBanner extends StatefulWidget {
//   final List<BannerModel>? banners;
  
//   const SliderBanner({super.key, this.banners});

//   @override
//   State<SliderBanner> createState() => _SliderBannerState();
// }

// class _SliderBannerState extends State<SliderBanner> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // ແຖບໂຄສະນາຫຼັກ
//         SizedBox(
//           height: 150,
//           child: PageView(
//             controller: _pageController,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             children: widget.banners != null && widget.banners!.isNotEmpty
//                 ? widget.banners!.map((banner) => _buildBannerItem(banner)).toList()
//                 : [
//                     _buildBannerItem(null),
//                     _buildBannerItem(null),
//                     _buildBannerItem(null),
//                   ],
//           ),
//         ),

//         // ຕົວຊີ້ຕຳແຫນ່ງຂອງສະໄລດ໌
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(widget.banners?.length ?? 3, (index) {
//               return Container(
//                 width: 8,
//                 height: 8,
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _currentPage == index
//                       ? const Color(0xFFFFCC00)
//                       : Colors.grey.withOpacity(0.5),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBannerItem(BannerModel? banner) {
//     // ລໍຖ້າຮູບພາບຈາກ Figma (ຈະເພີ່ມພາຍຫຼັງ)
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFF222222),
//         borderRadius: BorderRadius.circular(12),
//         image: DecorationImage(
//           fit: BoxFit.cover,
//           image: banner?.imageUrl != null
//               ? AssetImage(banner!.imageUrl) // ໃຊ້ຮູບຈາກ model
//               : const AssetImage('assets/placeholder.png'), // ຈະແທນທີ່ດ້ວຍຮູບຈາກ Figma
//         ),
//       ),
//       child: Stack(
//         children: [
//           // ແຖບດຳຊື່ແບຣນ
//           Positioned(
//             left: 0,
//             bottom: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(12),
//                   bottomRight: Radius.circular(12),
//                 ),
//                 color: Colors.black.withOpacity(0.6),
//               ),
//               child: Row(
//                 children: [
//                   // ໂລໂກ້ບໍລິສັດ
//                   Container(
//                     width: 24,
//                     height: 24,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFFFCC00),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'M',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     banner?.companyName ?? 'THE SMI TAXI',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           // ສ່ວນຂອງຂໍ້ຄວາມໂຄສະນາ
//           Positioned(
//             left: 16,
//             top: 16,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   banner?.title ?? 'MAUDO YOU',
//                   style: const TextStyle(
//                     color: Color(0xFFFFCC00),
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   banner?.subtitle ?? 'MAKETING',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }