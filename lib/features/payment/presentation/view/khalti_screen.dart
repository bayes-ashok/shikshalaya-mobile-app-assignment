// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
// import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';
// import 'package:shikshalaya/features/home/presentation/view/dashboard_view.dart';
// import 'package:shikshalaya/features/test/presentation/view/test_screen.dart';
// import '../view_model/payment_bloc.dart';
//
// class KhaltiSDKDemo extends StatefulWidget {
//   final CourseEntity course;
//
//   const KhaltiSDKDemo({super.key, required this.course});
//
//   @override
//   State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
// }
// class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
//   Future<Khalti?>? khaltiFuture;
//   Khalti? khalti;
//   PaymentResult? paymentResult;
//   String? pidx; // Pidx should be updated from Bloc
//   String pidxx="yrxr4mg8diGPWkjEiW474T";
//   @override
//   void initState() {
//     super.initState();
//     // Trigger Pidx Generation when the page loads
//     context.read<PaymentBloc>().add(GeneratePidxEvent(widget.course.courseId));
//     khaltiFuture=initializeKhalti();
//   }
//
//   Future<Khalti?> initializeKhalti() async {
//     final payConfig = KhaltiPayConfig(
//       publicKey: '3ff578acbc104826a4ffd11b989a079f',
//       pidx: pidxx,
//       environment: Environment.test,
//     );
//
//     try {
//       final khaltiInstance = await Khalti.init(
//         enableDebugging: true,
//         payConfig: payConfig,
//         onPaymentResult: (paymentResult, khaltiInstance) {
//           log(paymentResult.toString());
//           setState(() {
//             this.paymentResult = paymentResult;
//           });
//           khaltiInstance.close(context);
//         },
//         onMessage: (
//             khaltiInstance, {
//               description,
//               statusCode,
//               event,
//               needsPaymentConfirmation,
//             }) async {
//           log(
//             'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
//           );
//           khaltiInstance.close(context);
//         },
//         onReturn: () => log('Successfully redirected to return_url.'),
//       );
//
//       setState(() {
//         khalti = khaltiInstance;
//       });
//
//       return khaltiInstance;
//     } catch (error) {
//       log('Error initializing Khalti: $error');
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<PaymentBloc, PaymentState>(
//       listener: (context, state) {
//         if (state is PidxGenerated) {
//           print('Received pidx: ${state.pidx}');
//           setState(() {
//             pidx = state.pidx;
//           });
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Payment',
//             style: TextStyle(color: Colors.black),
//           ),
//           backgroundColor: Colors.white,
//           elevation: 1,
//           iconTheme: const IconThemeData(color: Colors.black),
//         ),
//         body: FutureBuilder<Khalti?>(
//           future: khaltiFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError || !snapshot.hasData) {
//               return const Center(child: Text('Failed to initialize Khalti.'));
//             }
//
//             final khaltiSnapshot = snapshot.data!;
//
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Course Image
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       widget.course.image,
//                       height: 150,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Course Title & Instructor
//                   Text(
//                     widget.course.title,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     'Instructor: ${widget.course.instructorName}',
//                     style: const TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Payment Summary
//                   Card(
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           const Text(
//                             'Payment Summary',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Course Fee:',
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                               Text(
//                                 'Rs. ${widget.course.pricing.toStringAsFixed(2)}',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.teal,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Pay with Khalti Button (Disabled until pidx is available)
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: const BorderSide(color: Colors.purple),
//                       ),
//                     ),
//                     onPressed: () => khaltiSnapshot.open(context), // Fixes the syntax error
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset(
//                           'assets/images/khalti_logo.png',
//                           height: 25,
//                         ),
//                         const SizedBox(width: 10),
//                         const Text(
//                           'Pay with Khalti',
//                           style: TextStyle(fontSize: 18, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//
//                   // Payment Result
//                   if (paymentResult != null) ...[
//                     const Text(
//                       'Payment Details',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text('pidx: ${paymentResult!.payload?.pidx}', style: const TextStyle(fontSize: 16)),
//                     Text('Status: ${paymentResult!.payload?.status}', style: const TextStyle(fontSize: 16)),
//                     Text('Amount Paid: Rs. ${paymentResult!.payload?.totalAmount}', style: const TextStyle(fontSize: 16)),
//                     Text('Transaction ID: ${paymentResult!.payload?.transactionId}', style: const TextStyle(fontSize: 16)),
//                     const SizedBox(height: 20),
//                   ],
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
//


import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';
import 'package:shikshalaya/features/course/presentation/view/course_detail_page.dart';
import 'package:shikshalaya/features/home/presentation/view/dashboard_view.dart';
import 'package:shikshalaya/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:shikshalaya/features/payment/presentation/view_model/payment_bloc.dart';
import 'package:shikshalaya/features/test/presentation/view/test_screen.dart';

import '../../../../app/di/di.dart';

class KhaltiSDKDemo extends StatefulWidget {
  final CourseEntity course;
  final String pidx;
  const KhaltiSDKDemo({super.key, required this.course, required this.pidx});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  Future<Khalti?>? khaltiFuture;
  Khalti? khalti;

  String pidx = 'EapYpUv44zrdzM9x2B75zh';
  PaymentResult? paymentResult;

  @override
  void initState() {
    super.initState();
    print("yayyyy ${widget.pidx}");
    khaltiFuture = initializeKhalti();
  }

  Future<Khalti?> initializeKhalti() async {
    final payConfig = KhaltiPayConfig(
      publicKey: '3ff578acbc104826a4ffd11b989a079f',
      pidx: widget.pidx,
      environment: Environment.test,
    );

    try {
      final khaltiInstance = await Khalti.init(
        enableDebugging: true,
        payConfig: payConfig,
        onPaymentResult: (paymentResult, khaltiInstance) {
          log(paymentResult.toString());
          setState(() {
            this.paymentResult = paymentResult;
          });
          khaltiInstance.close(context);
        },
        onMessage: (
            khaltiInstance, {
              description,
              statusCode,
              event,
              needsPaymentConfirmation,
            }) async {
          log(
            'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
          );
          khaltiInstance.close(context);
        },
        onReturn: () => log('Successfully redirected to return_url.'),
      );

      setState(() {
        khalti = khaltiInstance;
      });

      return khaltiInstance;
    } catch (error) {
      log('Error initializing Khalti: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khalti Payment Demo'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: FutureBuilder<Khalti?>(
          future: khaltiFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Text('Failed to initialize Khalti.');
            }

            final khaltiSnapshot = snapshot.data!;

            // Check paymentResult status and navigate automatically
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (paymentResult != null && paymentResult!.payload?.status == "Completed") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TestScreen()),
                );
              }
            });

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.course.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.course.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Instructor: ${widget.course.instructorName}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.category, color: Colors.teal),
                      const SizedBox(width: 8),
                      Text(widget.course.category,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Payment Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Course Fee:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Rs. ${widget.course.pricing.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.purple),
                        ),
                      ),
                      onPressed: () => khaltiSnapshot.open(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/khalti_logo.png',
                            height: 25,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Pay with Khalti',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Remove button if payment is completed
                  if (paymentResult != null && paymentResult!.payload?.status != "Completed")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      onPressed: () {
                        if (paymentResult!.payload?.status == "Completed") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => TestScreen()),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider.value(
                                    value: getIt<HomeCubit>(),
                                    child: DashboardView(),
                                  ),
                            ),
                          );
                        }
                      },
                      child: const Text('Proceed'),
                    ),

                  const SizedBox(height: 40),
                  const Text(
                    'This is a demo application developed by a merchant.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}