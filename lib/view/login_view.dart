import 'package:flutter/material.dart';
import 'package:shikshalaya/common/common_snackbar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("login"),
      ),
      body: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            CommonSnackbar.show(
              context,
              message: "This is a common snackbar!",
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            );
          },
          child: const Text("Button 1"),
        ),
      ),
    );
  }
}
