// import 'package:flutter/material.dart';
//
// import 'success_payment_package_bottomsheet.dart';
//
// class PaymentMethodBottomSheet extends StatefulWidget {
//   const PaymentMethodBottomSheet({super.key});
//
//   @override
//   _PaymentMethodBottomSheetState createState() => _PaymentMethodBottomSheetState();
// }
//
// class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
//   int _selectedMethod = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title
//           const Text(
//             'طريقة الدفع',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           // Payment Methods List
//           _buildPaymentOption(0, 'كاش', Icons.attach_money, ''),
//           const SizedBox(height: 8),
//           _buildPaymentOption(1, 'xxx 656565655', Icons.credit_card, 'assets/Icons/mastercard_logo.png'),
//           const SizedBox(height: 8),
//           _buildPaymentOption(2, 'xxx 65656', Icons.credit_card, 'assets/Icons/visa_logo.png'),
//           const SizedBox(height: 16),
//           GestureDetector(
//             onTap: () {
//               // Logic to add new payment method
//             },
//             child: const Row(
//               children: [
//                 Icon(Icons.add, color: Colors.red),
//                 SizedBox(width: 8),
//                 Text(
//                   'إضافة طريقة دفع',
//                   style: TextStyle(color: Colors.black, fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   height: 60,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       showModalBottomSheet(
//                         context: context,
//                         builder: (context) {
//                           return const SubscriptionSuccessBottomSheet();
//                         },
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                         ),
//                         isScrollControlled: true,
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red, // Pay Button Color
//                     ),
//                     child: const Text(
//                       'ادفع 500',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: SizedBox(
//                   height: 60,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context); // Close the bottom sheet
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey[300], // Cancel Button Color
//                     ),
//                     child: const Text(
//                       'تراجع',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   // Widget to build each payment option
//   Widget _buildPaymentOption(int value, String text, IconData icon, String logoAsset) {
//     return ListTile(
//       leading: logoAsset.isEmpty ? Icon(icon, color: _selectedMethod == value ? Colors.red : Colors.grey) : Image.asset(logoAsset, width: 24, height: 24),
//       title: Text(text),
//       trailing: Radio(
//         value: value,
//         groupValue: _selectedMethod,
//         onChanged: (int? val) {
//           setState(() {
//             _selectedMethod = val!;
//           });
//         },
//         activeColor: Colors.red,
//       ),
//     );
//   }
// }
