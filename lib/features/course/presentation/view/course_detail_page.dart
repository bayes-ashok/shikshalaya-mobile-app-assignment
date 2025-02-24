import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/video_screen/presentation/view/video_lecture_screen.dart';
import 'package:video_player/video_player.dart';

import '../../../payment/presentation/view/khalti_payment.dart';
import '../view_model/bloc/course_bloc.dart';

class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({super.key});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(PrintCourseIdEvent());
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    String videoUrl =
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

    // Initialize the FlickManager with the video URL
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          setState(() {});
        }).catchError((error) {
          print('Error loading video: $error');
        }),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Course Details'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Lessons'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),
        body: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: FlickVideoPlayer(
                flickManager: flickManager, // Using flickManager here
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  OverviewTab(),
                  LessonsTab(),
                  ReviewsTab(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoLectureScreen()),
              );

            },
            child: Text(
              'GET ENROLL',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}


class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Section Officer – Written Paper | शाखा अधिकृत लेखनमिति पत्र',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('By Edusoft Academy'),
          SizedBox(height: 8),
          Row(
            children: List.generate(
                5, (index) => Icon(Icons.star, color: Colors.amber)),
          ),
          SizedBox(height: 8),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer rhoncus vitae nisl...',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: () {},
            child: Text('Read More'),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoBox(icon: Icons.video_library, text: '80+ Lectures'),
              InfoBox(icon: Icons.schedule, text: '12 Weeks'),
            ],
          ),
        ],
      ),
    );
  }
}

class LessonsTab extends StatelessWidget {
  LessonsTab({super.key});
  final List<String> lessons = [
    '1.1 शासनको महत्त्व, अवधारणा, सन्दर्भ र विशेषता',
    '1.2 शासनको राजनीतिक तथा प्रशासनिक संरचना',
    '1.3 सूचनाको हक र पारदर्शिता',
    '1.4 राष्ट्र निर्माण र राज्य निर्माण',
    '1.5 नेपालको शासन प्रणाली',
    '1.6 बहुस्तरीय शासन र नेपाल',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(lessons[index]),
        );
      },
    );
  }
}

class ReviewsTab extends StatelessWidget {
  ReviewsTab({super.key});
  final List<Map<String, String>> reviews = [
    {'name': 'Ashok Sah', 'review': 'Great course, very informative!'},
    {'name': 'Sanim Poudyal', 'review': 'Helped me a lot in my preparation.'},
    {'name': 'Sudeep Khadka', 'review': 'Amazing content and well-structured.'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reviews[index]['name']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Row(
                children: List.generate(
                    5, (i) => Icon(Icons.star, color: Colors.amber, size: 16)),
              ),
              SizedBox(height: 4),
              Text(reviews[index]['review']!),
            ],
          ),
        );
      },
    );
  }
}

class InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoBox({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
