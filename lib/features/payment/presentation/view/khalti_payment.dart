import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:shikshalaya/features/course/presentation/view/course_detail_page.dart';
import 'package:shikshalaya/features/home/presentation/view/dashboard_view.dart';
import 'package:shikshalaya/features/test/presentation/view/test_screen.dart';

class KhaltiSDKDemo extends StatefulWidget {
  const KhaltiSDKDemo({super.key});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  Future<Khalti?>? khaltiFuture;
  Khalti? khalti;

  String pidx = 'KdY9wKo7EJjA8HWyWk4QqW';
  PaymentResult? paymentResult;

  @override
  void initState() {
    super.initState();
    khaltiFuture = initializeKhalti();
  }

  Future<Khalti?> initializeKhalti() async {
    final payConfig = KhaltiPayConfig(
      publicKey: '3ff578acbc104826a4ffd11b989a079f',
      pidx: pidx,
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
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/khalti_logo.png',
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Rs. 10',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '1 day fee',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      side: const BorderSide(color: Colors.teal),
                    ),
                    onPressed: () => khaltiSnapshot.open(context),
                    child: const Text(
                      'Pay with Khalti',
                      style: TextStyle(fontSize: 18, color: Colors.teal),
                    ),
                  ),
                  const SizedBox(height: 40),
                  paymentResult == null
                      ? Text(
                    'pidx: $pidx',
                    style: const TextStyle(fontSize: 16),
                  )
                      : Column(
                    children: [
                      Text(
                        'pidx: ${paymentResult!.payload?.pidx}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Status: ${paymentResult!.payload?.status}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Amount Paid: ${paymentResult!.payload?.totalAmount}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Transaction ID: ${paymentResult!.payload?.transactionId}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        onPressed: () {
                          if (paymentResult!.payload?.status == "Complete") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TestScreen()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DashboardView()),
                            );
                          }
                        },
                        child: const Text('Proceed'),
                      ),
                    ],
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
