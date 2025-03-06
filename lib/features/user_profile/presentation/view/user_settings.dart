import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shikshalaya/features/course/presentation/view_model/bloc/course_bloc.dart';
import '../../../../app/di/di.dart';
import '../../../auth/presentation/view/login_view.dart';
import '../../../auth/presentation/view_model/login/login_bloc.dart';
import '../../../course/presentation/view/student_course.dart';
import '../view_model/settings_bloc.dart';
import 'edit_profile_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showTerms = false;
  bool showHelpCenter = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SettingsBloc>(context).add(LoadUserProfile());
  }

  void _logout(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Clear user session data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Wait for UI update before navigating
    await Future.delayed(const Duration(seconds: 2));

    // Ensure the context is still mounted
    if (!context.mounted) return;

    // Navigate to LoginView
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: getIt<LoginBloc>(),
          child: const LoginView(),
        ),
      ),
          (route) => false, // Remove all previous screens
    );
  }

  /// Function to authenticate user using fingerprint
  Future<bool> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true, // Keeps authentication session active
          biometricOnly: true, // Restricts to biometric authentication only
        ),
      );
    } on PlatformException catch (e) {
      print("Authentication error: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication failed: ${e.message}")),
      );
      return false;
    }
    return authenticated;
  }


  void _navigateToEditProfile(BuildContext context) async {
    bool isAuthenticated = await _authenticateWithBiometrics();
    if (isAuthenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<SettingsBloc>(),
            child: const EditProfileScreen(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication failed")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      // Wrap the entire body in a Container with gradient
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf0faff),
              Color(0xFFe6f7ff),
            ],
          ),
        ),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SettingsLoaded) {
              return _buildSettingsContent(state);
            } else {
              return const Center(child: Text("Error loading profile."));
            }
          },
        ),
      ),
    );
  }

  Widget _buildSettingsContent(SettingsLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _profileCard(state),
          const SizedBox(height: 20),
          // Wrap the card container inside another Container to maintain gradient
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                settingsOption(
                  Icons.person,
                  "Edit Profile",
                  false,
                  () => _navigateToEditProfile(
                      context), // 🔹 Call authentication function
                ),
                settingsOption(Icons.menu_book, "My Learning", false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: getIt<CourseBloc>(),
                        child: const CourseGridScreen(),
                      ),
                    ),
                  );
                }),
                expandableOption(
                  icon: Icons.description,
                  title: "Terms & Conditions",
                  isExpanded: showTerms,
                  onTap: () {
                    setState(() {
                      showTerms = !showTerms;
                    });
                  },
                  content: [
                    "We may collect and use your data for analytics and service improvements.",
                    "Your data may be shared with partnered institutions.",
                    "All purchases are subject to our refund and cancellation policy."
                  ],
                ),
                expandableOption(
                  icon: Icons.headset_mic,
                  title: "Help Center",
                  isExpanded: showHelpCenter,
                  onTap: () {
                    setState(() {
                      showHelpCenter = !showHelpCenter;
                    });
                  },
                  content: [
                    "For technical issues, contact support@loksewaapp.com.",
                    "For enrollment and payment issues, reach out via our helpline.",
                    "Check FAQs for common questions before reaching support."
                  ],
                ),
                settingsOption(
                  Icons.exit_to_app,
                  "Logout",
                  false,
                      () => _logout(context), // 🔹 Directly call logout function
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _profileCard(SettingsLoaded state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 40, color: Colors.black),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.userProfile.fName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                state.userProfile.email,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget settingsOption(
      IconData icon, String title, bool isExpandable, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          trailing: isExpandable
              ? const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.black)
              : null,
          onTap: onTap,
        ),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  Widget expandableOption({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<String> content,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
              size: 20,
              color: Colors.black),
          onTap: onTap,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: isExpanded
              ? const EdgeInsets.symmetric(horizontal: 15, vertical: 10)
              : EdgeInsets.zero,
          height: isExpanded ? null : 0,
          child: isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: content
                      .map((item) => Text("• $item",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87)))
                      .toList(),
                )
              : null,
        ),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }
}
