import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/home/presentation/view/home_view.dart';
import 'package:shikshalaya/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:shikshalaya/features/test/presentation/view/test_screen.dart';
import 'package:shikshalaya/features/test/presentation/view_model/bloc/test_bloc.dart';

import '../../app/di/di.dart';
import '../../features/auth/presentation/view/login_view.dart';
import '../../features/auth/presentation/view_model/login/login_bloc.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different screens based on selected index
    switch (index) {
      case 0:
      //
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: getIt<HomeCubit>(),
              child: const HomeView(),
            ),
          ),
        );
        break;
      case 1:

        break;
      case 2:
      // Navigate to News screen (if applicable)
        break;
      case 3:
      // Navigate to Profile screen (if applicable)
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepPurpleAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Test',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}