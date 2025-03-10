import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/di/di.dart';
import '../../../auth/presentation/view/login_view.dart';
import '../../../auth/presentation/view_model/login/login_bloc.dart';
import '../view_model/cubit/home_cubit.dart';
import '../view_model/cubit/home_state.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final double _shakeThreshold =
      20.0; // Adjust this value to detect shakes properly

  @override
  void initState() {
    super.initState();

    _streamSubscriptions.add(
      accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          setState(() {
            _detectShake(event);
          });
        },
        onError: (e) {
          showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support the Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
  }

  void _detectShake(AccelerometerEvent event) async {
    double magnitude =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    print("Shake detected with magnitude: $magnitude");

    if (magnitude > _shakeThreshold) {
      print("Shake detected!");

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Clear user session data
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Wait to simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Ensure the widget is still active
      if (!mounted) return;

      // Close the dialog before navigating
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Ensure navigation happens safely
      Future.microtask(() {
        if (mounted) {
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
      });

      // Reset the shake message after delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFf0faff),
              Color(0xFFe6f7ff),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures balance
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFilterChips(context),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Explore Courses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Added padding
                child: _buildCourseGrid(context),
              ),
            ),
            const SizedBox(height: 20), // Add space at bottom
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search Here',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterChip(
                    label: 'All',
                    isSelected: state.selectedCategory == 'all',
                    onSelected: () => homeCubit.filterCoursesByLevel('all'),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Officer',
                    isSelected: state.selectedCategory == 'section-officer',
                    onSelected: () =>
                        homeCubit.filterCoursesByLevel('section-officer'),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Nayab Subba',
                    isSelected: state.selectedCategory == 'nayab-subba',
                    onSelected: () =>
                        homeCubit.filterCoursesByLevel('nayab-subba'),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Kharidar',
                    isSelected: state.selectedCategory == 'kharidar',
                    onSelected: () =>
                        homeCubit.filterCoursesByLevel('kharidar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Roboto Bold',
          color: isSelected
              ? Colors.white
              : Colors.black, // Change text color when selected
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: Colors.white,
      selectedColor: Colors.deepPurpleAccent,
      checkmarkColor: isSelected
          ? Colors.white
          : null, // Make checkmark white when selected
    );
  }

  Widget _buildCourseGrid(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFf0faff),
                  Color(0xFFe6f7ff),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const CircularProgressIndicator(),
          );
        }

        if (!state.isSuccess) {
          return Center(
            child: Text(state.errorMessage ?? "Failed to load courses"),
          );
        }

        if (state.filteredCourses.isEmpty) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            child: const Text("No courses available"),
          );
        }

        return Container(
          // Ensure grid inherits background
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFf0faff),
                Color(0xFFe6f7ff),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 2
                      : 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 3 / 4
                      : 20 / 17,
            ),
            itemCount: state.filteredCourses.length,
            itemBuilder: (context, index) {
              final course = state.filteredCourses[index];
              return GestureDetector(
                onTap: () {
                  context
                      .read<HomeCubit>()
                      .navigateToCourseDetail(context, course.courseId);
                },
                child: buildCourseCard(
                  title: course.title,
                  subtitle: course.instructorName ?? "Unknown Instructor",
                  imagePath: course.image,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildCourseCard({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    String formattedTitle =
        title.length > 50 ? "${title.substring(0, 47)}.." : title;

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double cardHeight =
        isPortrait ? 250 : 100; // Adjust card height for landscape
    double imageHeight = isPortrait ? 140 : 110; // Maintain aspect ratio

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFf0faff),
            Color(0xFFe6f7ff),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Card(
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Full Visibility
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9, // Maintain image's original aspect ratio
                child: Image.network(
                  imagePath,
                  width: double.infinity,
                  fit:
                      BoxFit.contain, // Ensure full visibility without cropping
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                formattedTitle,
                style: const TextStyle(
                  fontFamily: 'OpenSans Bold',
                  fontSize: 14,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4), // Reduce space

            // Instructor Name Section (Tightly Aligned)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontFamily: 'OpenSans Medium',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
