// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 248, 246, 246),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search Here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Colors.deepPurpleAccent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 16),
                // Filter Chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterChip(
                      label: const Text(
                        'Loksewa',
                        style: TextStyle(
                          fontFamily: 'Roboto Bold',
                        ),
                      ),
                      onSelected: (_) {},
                      backgroundColor: Colors.deepPurple.shade50,
                      selectedColor: Colors.deepPurpleAccent,
                      selected: false,
                    ),
                    FilterChip(
                      label: const Text(
                        'Bridge Course',
                        style: TextStyle(
                          fontFamily: 'Roboto Bold',
                        ),
                      ),
                      onSelected: (_) {},
                      backgroundColor: Colors.deepPurple.shade50,
                      selectedColor: Colors.deepPurpleAccent,
                      selected: false,
                    ),
                    FilterChip(
                      label: const Text(
                        'CEE',
                        style: TextStyle(
                          fontFamily: 'Roboto Bold',
                        ),
                      ),
                      onSelected: (_) {},
                      backgroundColor: Colors.deepPurple.shade50,
                      selectedColor: Colors.deepPurpleAccent,
                      selected: false,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Explore Courses Section
                const Text(
                  'Explore Courses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 2
                        : 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 3 / 4
                        : 20 / 17,
                  ),
                  itemCount: cardData.length,
                  itemBuilder: (context, index) {
                    return buildCourseCard(
                      title: cardData[index]['title']!,
                      subtitle: cardData[index]['subtitle']!,
                      imagePath: cardData[index]['imagePath']!,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCourseCard({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
              color: Color.fromARGB(255, 88, 72, 72), width: 1)),
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
                      .withOpacity(0.4), // Add dark overlay for readability
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
