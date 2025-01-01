import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/cubit/dashboard_cubit.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 6,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/icon.png'),
            ),
            SizedBox(width: 10),
            Text(
              'Welcome, ASHOK',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans SemiBold',
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<DashboardCubit, int>(
        builder: (context, state) {
          final cubit = context.read<DashboardCubit>();
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: cubit.getScreen(state),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<DashboardCubit, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            currentIndex: state,
            onTap: (index) {
              context.read<DashboardCubit>().navigateTo(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  state == 0 ? Icons.home : Icons.home_outlined,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  state == 1
                      ? Icons.library_books
                      : Icons.library_books_outlined,
                ),
                label: 'Tests',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  state == 2 ? Icons.newspaper : Icons.newspaper_outlined,
                ),
                label: 'News',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  state == 3 ? Icons.person : Icons.person_outline,
                ),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}
