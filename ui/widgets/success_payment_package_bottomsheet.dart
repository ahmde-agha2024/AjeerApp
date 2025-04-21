// import 'package:flutter/material.dart';
//
// class SubscriptionSuccessBottomSheet extends StatelessWidget {
//   const SubscriptionSuccessBottomSheet({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Success Icon
//           const Icon(
//             Icons.check_circle,
//             color: Colors.green,
//             size: 80,
//           ),
//           const SizedBox(height: 16),
//           // Success Message
//           const Text(
//             'تم الاشتراك بنجاح',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 8),
//           // Description
//           const Text(
//             'تهانينا لك لقد اشتركت في الباقة الذهبية الآن و استمتع ب 100 طلب خاص بك مع أجير',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 32),
//           // Return to Home Button
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context); // Close the bottom sheet
//               // Add your navigation to the home screen here
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//             ),
//             child: const Text(
//               'العودة للرئيسية',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
// }
