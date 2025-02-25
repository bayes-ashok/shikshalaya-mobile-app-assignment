import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late FlickManager flickManager;
  double? videoAspectRatio; // Store video aspect ratio

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    VideoPlayerController controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    controller.initialize().then((_) {
      setState(() {
        videoAspectRatio = controller.value.aspectRatio; // Get actual aspect ratio
      });
    }).catchError((error) {
      print('Error loading video: $error');
    });

    flickManager = FlickManager(videoPlayerController: controller);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Player")),
      body: Center(
        child: videoAspectRatio != null
            ? AspectRatio(
          aspectRatio: videoAspectRatio!,
          child: FlickVideoPlayer(flickManager: flickManager),
        )
            : const CircularProgressIndicator(), // Show loader until initialized
      ),
    );
  }
}
