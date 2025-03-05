import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/validator/register_validator.dart';
import '../view_model/signup/register_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _img;

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied || status.isRestricted) {
      await Permission.camera.request();
    }
  }

  Future<void> _browseImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        setState(() {
          _img = File(image.path);
          context.read<RegisterBloc>().add(LoadImage(file: _img!));
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      final registerState = context.read<RegisterBloc>().state;
      context.read<RegisterBloc>().add(
        RegisterStudent(
          context: context,
          fName: _fullNameController.text,
          phone: _phoneNumberController.text,
          email: _emailController.text,
          password: _passwordController.text,
          image: registerState.imageName,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe1f5fe), Color(0xFFb3e5fc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30,),
                    Text(
                      'Create New Account!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[800],
                      ),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.grey[300],
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _checkCameraPermission();
                                    _browseImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.camera),
                                  label: const Text('Camera'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _browseImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.image),
                                  label: const Text('Gallery'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 125,
                        width: 125,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _img != null
                              ? FileImage(_img!)
                              : const NetworkImage(
                              'https://cdn-icons-png.freepik.com/512/5178/5178994.png')
                          as ImageProvider,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: _inputDecoration('Full Name', Icons.person),
                      validator: ValidationUtils.validateFullName,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration('Email', Icons.email),
                      validator: ValidationUtils.validateEmail,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: _inputDecoration('Phone Number', Icons.phone),
                      validator: ValidationUtils.validatePhoneNumber,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration('Password', Icons.lock),
                      validator: ValidationUtils.validatePassword,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: _inputDecoration('Confirm Password', Icons.lock_outline),
                      validator: (value) => ValidationUtils.validateConfirmPassword(value, _passwordController.text),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? ', style: TextStyle(fontSize: 16)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
