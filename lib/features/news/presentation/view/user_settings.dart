// import 'package:flutter/material.dart';
//
// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});
//
//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }
//
// class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
//   bool showTerms = false;
//   bool showHelpCenter = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {},
//         ),
//         title: const Text(
//           "Settings",
//           style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.notifications_none, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             profileCard(),
//             const SizedBox(height: 20),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   settingsOption(Icons.person, "Edit Profile", false, () {}),
//                   settingsOption(Icons.menu_book, "My Learning", false, () {}),
//                   expandableOption(
//                     icon: Icons.description,
//                     title: "Terms & Conditions",
//                     isExpanded: showTerms,
//                     onTap: () {
//                       setState(() {
//                         showTerms = !showTerms;
//                       });
//                     },
//                     content: [
//                       "We may collect and use your data for analytics and service improvements.",
//                       "Your data may be shared with partnered institutions.",
//                       "All purchases are subject to our refund and cancellation policy."
//                     ],
//                   ),
//                   expandableOption(
//                     icon: Icons.headset_mic,
//                     title: "Help Center",
//                     isExpanded: showHelpCenter,
//                     onTap: () {
//                       setState(() {
//                         showHelpCenter = !showHelpCenter;
//                       });
//                     },
//                     content: [
//                       "For technical issues, contact support@loksewaapp.com.",
//                       "For enrollment and payment issues, reach out via our helpline.",
//                       "Check FAQs for common questions before reaching support."
//                     ],
//                   ),
//                   settingsOption(Icons.exit_to_app, "Logout", false, () {}),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget profileCard() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 10,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Stack(
//             children: [
//               CircleAvatar(
//                 radius: 40,
//                 backgroundColor: Colors.grey[300],
//                 child: const Icon(Icons.person, size: 40, color: Colors.black),
//               ),
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.blueAccent,
//                   ),
//                   child: const Icon(Icons.edit, size: 16, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text("John Doe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 5),
//               Text("johndoe@email.com", style: TextStyle(fontSize: 14, color: Colors.grey)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget settingsOption(IconData icon, String title, bool isExpandable, VoidCallback onTap) {
//     return Column(
//       children: [
//         ListTile(
//           leading: Icon(icon, color: Colors.black),
//           title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
//           trailing: isExpandable ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black) : null,
//           onTap: onTap,
//         ),
//         Divider(height: 1, color: Colors.grey[300]),
//       ],
//     );
//   }
//
//   Widget expandableOption({
//     required IconData icon,
//     required String title,
//     required bool isExpanded,
//     required VoidCallback onTap,
//     required List<String> content,
//   }) {
//     return Column(
//       children: [
//         ListTile(
//           leading: Icon(icon, color: Colors.black),
//           title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
//           trailing: Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios, size: 20, color: Colors.black),
//           onTap: onTap,
//         ),
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           padding: isExpanded ? const EdgeInsets.symmetric(horizontal: 15, vertical: 10) : EdgeInsets.zero,
//           height: isExpanded ? null : 0,
//           child: isExpanded
//               ? Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: content.map((item) => Text("• $item", style: const TextStyle(fontSize: 14, color: Colors.black87))).toList(),
//           )
//               : null,
//         ),
//         Divider(height: 1, color: Colors.grey[300]),
//       ],
//     );
//   }
// }
