import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';
import 'package:shikshalaya/features/test/presentation/view/test_screen.dart';

import '../view_model/payment_bloc.dart';

class KhaltiSDKDemo extends StatefulWidget {
  final CourseEntity course;
  final String pidxx;
  const KhaltiSDKDemo({super.key, required this.course, required this.pidxx});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  late final Future<Khalti?> khalti;
  PaymentResult? paymentResult;

  @override
  void initState() {
    super.initState();
    final payConfig = KhaltiPayConfig(
      publicKey: '3ff578acbc104826a4ffd11b989a079f', // This is a dummy public key
      pidx: widget.pidxx,
      environment: Environment.test,
    );

    khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) {
        log(paymentResult.toString());
        setState(() {
          this.paymentResult = paymentResult;
        });

        // Close Khalti Payment Page
        khalti.close(context);
      },
      onMessage: (
          khalti, {
            description,
            statusCode,
            event,
            needsPaymentConfirmation,
          }) async {
        log(
          'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
        );
        khalti.close(context);
      },
      onReturn: () => log('Successfully redirected to return_url.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check for payment status and navigate when completed
    if (paymentResult?.payload?.status == "Completed") {
      Future.microtask(() {
        context.read<PaymentBloc>().add(OnPaymentCompleteEvent(context, widget.course));
      });
    }

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: khalti,
          initialData: null,
          builder: (context, snapshot) {
            final khaltiSnapshot = snapshot.data;
            if (khaltiSnapshot == null) {
              return const CircularProgressIndicator.adaptive();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/seru.png',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 120),
                const Text(
                  'Rs. 22',
                  style: TextStyle(fontSize: 25),
                ),
                const Text('1 day fee'),
                OutlinedButton(
                  onPressed: () => khaltiSnapshot.open(context),
                  child: const Text('Pay with Khalti'),
                ),
                const SizedBox(height: 120),
                paymentResult == null
                    ? Text(
                  'pidx: ${widget.pidxx}',
                  style: const TextStyle(fontSize: 15),
                )
                    : Column(
                  children: [
                    Text(
                      'pidx: ${paymentResult!.payload?.pidx}',
                    ),
                    Text('Status: ${paymentResult!.payload?.status}'),
                    Text(
                      'Amount Paid: ${paymentResult!.payload?.totalAmount}',
                    ),
                    Text(
                      'Transaction ID: ${paymentResult!.payload?.transactionId}',
                    ),
                  ],
                ),
                const SizedBox(height: 120),
                const Text(
                  'This is a demo application developed by some merchant.',
                  style: TextStyle(fontSize: 12),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
