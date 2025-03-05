import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/auth/domain/entity/auth_entity.dart';
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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SettingsBloc>(context).add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            UserProfileEntity user = state.userProfile;

            // Pre-fill fields with user data
            _nameController.text = user.fName;
            _emailController.text = user.email;
            _phoneController.text = user.phone;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Full Name"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    enabled: false, // Email should not be editable
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: "Phone Number"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Save updated profile details (To be implemented)
                    },
                    child: const Text("Save Changes"),
                  ),
                ],
              ),
            );
          } else if (state is SettingsError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("User data not found"));
        },
      ),
    );
  }
}
