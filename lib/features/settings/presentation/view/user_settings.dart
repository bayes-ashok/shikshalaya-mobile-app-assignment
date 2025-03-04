import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class VideoLectureScreen extends StatefulWidget {
  const VideoLectureScreen({super.key});

  @override
  State<VideoLectureScreen> createState() => _VideoLectureScreenState();
}

class _VideoLectureScreenState extends State<VideoLectureScreen> {
  // List of Lectures with URLs
  final List<Map<String, dynamic>> lectures = [
    {
      "title": "Introduction to Flutter",
      "duration": "12:30",
      "progress": 0.75,
      "url": "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"
    },
    {
      "title": "State Management Basics",
      "duration": "10:45",
      "progress": 0.5,
      "url": "https://res.cloudinary.com/dzyebdugr/video/upload/v1736263178/samples/cld-sample-video.mp4"
    },
    {
      "title": "Working with APIs",
      "duration": "15:20",
      "progress": 0.25,
      "url": "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"
    },
    {
      "title": "Building UI Components",
      "duration": "9:50",
      "progress": 1.0,
      "url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Video Lectures'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Lecture List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: lectures.length,
              itemBuilder: (context, index) {
                return _buildLectureItem(
                  lectures[index]["title"],
                  lectures[index]["duration"],
                  lectures[index]["progress"],
                  lectures[index]["url"],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLectureItem(String title, String duration, double progress, String videoUrl) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.play_circle_fill, color: Colors.blueAccent, size: 40),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(duration),
            SizedBox(height: 5),
            LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[300]),
          ],
        ),
        trailing: Icon(Icons.more_vert),
        onTap: () {
          // Navigate to the full-screen video page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenVideoPage(videoUrl: videoUrl),
            ),
          );
        },
      ),
    );
  }
}

class FullScreenVideoPage extends StatelessWidget {
  final String videoUrl;

  const FullScreenVideoPage({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Video'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: FlickVideoPlayer(
            flickManager: FlickManager(
              videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(videoUrl))
                ..initialize().then((_) {
                  // setState() {}
                }).catchError((error) {
                  print('Error loading video: $error');
                }),
            ),
          ),
        ),
      ),
    );
  }
}
