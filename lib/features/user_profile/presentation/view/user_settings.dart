import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/di.dart';
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

  @override
  void initState() {
    super.initState();
    // 🔹 Load user profile when page opens
    BlocProvider.of<SettingsBloc>(context).add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
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
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: getIt<SettingsBloc>(),
                          child: const EditProfileScreen(),
                        ),
                      ),
                    ).then((_) {
                      // 🔹 Refresh profile when coming back from EditProfileScreen
                      BlocProvider.of<SettingsBloc>(context).add(LoadUserProfile());
                    });
                  },
                ),
                settingsOption(Icons.menu_book, "My Learning", false, () {}),
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
                settingsOption(Icons.exit_to_app, "Logout", false, () {}),
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget settingsOption(IconData icon, String title, bool isExpandable, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
          trailing: isExpandable ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black) : null,
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
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
          trailing: Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios, size: 20, color: Colors.black),
          onTap: onTap,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: isExpanded ? const EdgeInsets.symmetric(horizontal: 15, vertical: 10) : EdgeInsets.zero,
          height: isExpanded ? null : 0,
          child: isExpanded
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content.map((item) => Text("• $item", style: const TextStyle(fontSize: 14, color: Colors.black87))).toList(),
          )
              : null,
        ),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }
}
