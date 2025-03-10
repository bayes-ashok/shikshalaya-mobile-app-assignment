// import 'package:flutter/material.dart';

// class CommonSnackbar {
//   static void show({
//     required BuildContext context,
//     required String message,
//     Color backgroundColor = Colors.black,
//     Color textColor = Colors.white,
//     Duration duration = const Duration(seconds: 3),
//   }) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(color: textColor),
//         ),
//         backgroundColor: backgroundColor,
//         duration: duration,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

showMySnackBar({
  required BuildContext context,
  required String message,
  Color? color,
}) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.green,
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
