import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/course/presentation/view/course_detail_page.dart';
import 'package:shikshalaya/features/course/presentation/view_model/bloc/course_bloc.dart';

import '../view_model/cubit/home_cubit.dart';
import '../view_model/cubit/home_state.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildFilterChips(context),
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added padding
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
        contentPadding: const EdgeInsets.symmetric(
            vertical: 15, horizontal: 20),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                onSelected: () => homeCubit.filterCoursesByLevel('section-officer'),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Nayab Subba',
                isSelected: state.selectedCategory == 'nayab-subba',
                onSelected: () => homeCubit.filterCoursesByLevel('nayab-subba'),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'Kharidar',
                isSelected: state.selectedCategory == 'kharidar',
                onSelected: () => homeCubit.filterCoursesByLevel('kharidar'),
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
          color: isSelected ? Colors.white : Colors.black, // Change text color when selected
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: Colors.white,
      selectedColor: Colors.deepPurpleAccent,
      checkmarkColor: isSelected ? Colors.white : null, // Make checkmark white when selected
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

        return Container( // Ensure grid inherits background
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
              crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: MediaQuery.of(context).orientation == Orientation.portrait ? 3 / 4 : 20 / 17,
            ),
            itemCount: state.filteredCourses.length,
            itemBuilder: (context, index) {
              final course = state.filteredCourses[index];
              return GestureDetector(
                onTap: () {
                  context.read<HomeCubit>().navigateToCourseDetail(context, course.courseId);
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
    // Ensure title truncation with ".." if it exceeds the max limit
    String formattedTitle = title.length > 50 ? "${title.substring(0, 47)}.." : title;
    return Container(
      decoration: BoxDecoration(
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
        elevation: 6, // Increased elevation for better shadow
        shadowColor: Colors.black.withOpacity(0.2), // Subtle black shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white, // Stronger white color for better contrast
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  Image.network(
                    imagePath,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 130,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.3), // Slight overlay for readability
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Title Section with Proper Truncation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 42, // Space for 3 lines of text
                child: Text(
                  formattedTitle,
                  style: const TextStyle(
                    fontFamily: 'OpenSans Bold',
                    fontSize: 14,
                    color: Colors.black, // Stronger black for better readability
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Spacer(),
            // Subtitle Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: SizedBox(
                height: 18, // Restrict subtitle height
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
            ),
          ],
        ),
      ),
    );
  }
}
