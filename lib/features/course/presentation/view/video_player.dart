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
  FlickManager? flickManager;
  double? videoAspectRatio; // Store video aspect ratio
  bool isError = false; // Track errors

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final VideoPlayerController controller =
      VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

      await controller.initialize();
      setState(() {
        videoAspectRatio = controller.value.aspectRatio; // Get actual aspect ratio
        flickManager = FlickManager(videoPlayerController: controller);
        isError = false;
      });

      // Trigger full-screen mode after UI is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        flickManager?.flickControlManager?.enterFullscreen();
      });
    } catch (error) {
      setState(() {
        isError = true;
      });
      print('Error loading video: $error');
    }
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Player")),
      body: Center(
        child: isError
            ? const Text("Failed to load video", style: TextStyle(color: Colors.red, fontSize: 16))
            : videoAspectRatio != null && flickManager != null
            ? AspectRatio(
          aspectRatio: videoAspectRatio!,
          child: FlickVideoPlayer(flickManager: flickManager!),
        )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
