import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';

class KhaltiSDKDemo extends StatefulWidget {
  const KhaltiSDKDemo({super.key});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  late Future<Khalti?> khalti;

  String pidx =
      'fCgiQG9dPtm4iQdAi23Aaj';

  PaymentResult? paymentResult;

  @override
  void initState() {
    super.initState();
    final payConfig = KhaltiPayConfig(
      publicKey:
          '3ff578acbc104826a4ffd11b989a079f',
      pidx: pidx,
      environment: Environment.test,
    );

    // Simulating delay for testing purposes
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        khalti = Khalti.init(
          enableDebugging: true,
          payConfig: payConfig,
          onPaymentResult: (paymentResult, khalti) {
            log(paymentResult.toString());
            setState(() {
              this.paymentResult = paymentResult;
            });
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
        ).catchError((error) {
          log('Error initializing Khalti: $error');
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Khalti?>(
          future: khalti,
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final khaltiSnapshot = snapshot.data;
            if (khaltiSnapshot == null) {
              return const Text('Failed to initialize Khalti.');
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
                        'pidx: $pidx',
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
