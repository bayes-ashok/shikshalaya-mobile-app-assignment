import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/course/presentation/view/course_detail_page.dart';

import '../../../course/presentation/view_model/bloc/course_bloc.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
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
              Color(0xFFe1f5fe),
              Color(0xFFb3e5fc)
            ], // Light blue gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              _buildSearchBar(),
              const SizedBox(height: 16),
              // Filter Chips
              _buildFilterChips(),
              const SizedBox(height: 16),
              // Explore Courses Section
              const Text(
                'Explore Courses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildCourseGrid(context),
            ],
          ),
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

  Widget _buildFilterChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilterChip(
          label: const Text('Loksewa',
              style: TextStyle(fontFamily: 'Roboto Bold')),
          onSelected: (_) {},
          backgroundColor: Colors.deepPurple.shade50,
          selectedColor: Colors.deepPurpleAccent,
          selected: false,
        ),
        FilterChip(
          label: Text('Bridge Course',
              style: TextStyle(fontFamily: 'Roboto Bold')),
          onSelected: (_) {},
          backgroundColor: Colors.deepPurple.shade50,
          selectedColor: Colors.deepPurpleAccent,
          selected: false,
        ),
        FilterChip(
          label: Text('CEE', style: TextStyle(fontFamily: 'Roboto Bold')),
          onSelected: (_) {},
          backgroundColor: Colors.deepPurple.shade50,
          selectedColor: Colors.deepPurpleAccent,
          selected: false,
        ),
      ],
    );
  }

  Widget _buildCourseGrid(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
        MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio:
        MediaQuery.of(context).orientation == Orientation.portrait ? 3 / 4 : 20 / 17,
      ),
      itemCount: cardData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CourseBloc(),
                  child: CourseDetailPage(),
                ),
              ),
            );

          },
          child: buildCourseCard(
            title: cardData[index]['title']!,
            subtitle: cardData[index]['subtitle']!,
            imagePath: cardData[index]['imagePath']!,
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
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
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
                Image.asset(
                  imagePath,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 130,
                  width: double.infinity,
                  color: Colors.black
                      .withOpacity(0.4), // Dark overlay for readability
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Title Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'OpenSans Bold',
                fontSize: 14,
                color: Colors.black,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          // Subtitle Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
            child: Text(
              subtitle,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'OpenSans Medium',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),

    );
  }
}

final List<Map<String, String>> cardData = [
  {
    'title': 'Botany Theory Classes\nfor Common Entrance Examination (CEE)',
    'subtitle': 'By Hamro Academy',
    'imagePath': 'assets/images/cee_botany.png',
  },
  {
    'title': 'Entrance Preparation for Institute of Engineering (IOE)',
    'subtitle': 'By PEA Association Pvt. Ltd.',
    'imagePath': 'assets/images/ioe.png',
  },
  {
    'title': 'Section Officer – Written Paper',
    'subtitle': 'By Edusoft Academy',
    'imagePath': 'assets/images/section_officer.jpg',
  },
  {
    'title': 'Section officer - MOFA | Foreign Policy & International Relation',
    'subtitle': 'By NICE Institute',
    'imagePath': 'assets/images/mofa.jpg',
  },
  {
    'title': 'CEE Preparation Full Course (1 Year Validity)',
    'subtitle': 'By Hamro Academy',
    'imagePath': 'assets/images/cee.jpg',
  },
];