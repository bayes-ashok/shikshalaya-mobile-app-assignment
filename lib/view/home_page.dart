import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 3,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/icon.png'),
            ),
            SizedBox(width: 10),
            Text(
              'Welcome, ASHOK',
              style: TextStyle(color: Colors.white, fontSize: 18),
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
      body: SingleChildScrollView(
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
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Filter Chips
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilterChip(label: const Text('Loksewa'), onSelected: (_) {}),
                  FilterChip(
                      label: const Text('Bridge Course'), onSelected: (_) {}),
                  FilterChip(label: const Text('CEE'), onSelected: (_) {}),
                ],
              ),
              const SizedBox(height: 16),
              // Continue Watching Section
              const Text(
                'Explore Courses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent GridView from scrolling
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4, // Adjust height/width ratio of cards
                ),
                itemCount: cardData.length, // Number of cards
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Tests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildCourseCard({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          // Title Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
              style: const TextStyle(color: Colors.grey, fontSize: 12),
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
    'title': 'Section Officer – Written Paper | लेखा परीक्षा',
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
