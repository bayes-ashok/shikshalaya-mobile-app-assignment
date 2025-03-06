import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shikshalaya/features/user_profile/domain/entity/user_profile_entity.dart';
import '../view_model/settings_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  File? _image;

  String? _updateResponseMessage; // Stores API response message

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SettingsBloc>(context).add(LoadUserProfile());
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveChanges() {
    if (_currentPasswordController.text.isEmpty) {
      _showSnackBar("⚠️ Current Password is required!", Colors.orange);
      return;
    }

    BlocProvider.of<SettingsBloc>(context).add(
      UpdateUserProfile(
        context: context,
        fullName: _nameController.text,
        phone: _phoneController.text,
        image: _image,
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text.isNotEmpty ? _newPasswordController.text : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            _showSnackBar("✅ ${state.message}", Colors.green);
          } else if (state is SettingsError) {
            _showSnackBar("❌ ${_parseErrorMessage(state.message)}", Colors.red);
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SettingsLoaded) {
              _nameController.text = state.userProfile.fName;
              _emailController.text = state.userProfile.email;
              _phoneController.text = state.userProfile.phone;

              return _buildProfileForm(); // ✅ Now controllers will have data
            }
            return const Center(child: Text("User data not found")); // ✅ Show message if no data
          },
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : const NetworkImage('https://cdn-icons-png.freepik.com/512/5178/5178994.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),

            // Full Name
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Full Name', Icons.person),
            ),
            const SizedBox(height: 15),

            // Email (Not Editable)
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration('Email', Icons.email),
              enabled: false,
            ),
            const SizedBox(height: 15),

            // Phone Number
            TextFormField(
              controller: _phoneController,
              decoration: _inputDecoration('Phone Number', Icons.phone),
            ),
            const SizedBox(height: 15),

            // Current Password (Required)
            TextFormField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: _inputDecoration('Current Password', Icons.lock),
            ),
            const SizedBox(height: 15),

            // New Password (Optional)
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: _inputDecoration('New Password (Optional)', Icons.lock_outline),
            ),
            const SizedBox(height: 25),

            // Save Changes Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Display API Response Message
            if (_updateResponseMessage != null) ...[
              Text(
                _updateResponseMessage!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _updateResponseMessage!.contains("❌") ? Colors.red : Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _parseErrorMessage(String errorMessage) {
    if (errorMessage.contains("Incorrect current password")) {
      return "❌ Incorrect password. Try again!";
    }
    return "❌ Something went wrong. Please try again.";
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
