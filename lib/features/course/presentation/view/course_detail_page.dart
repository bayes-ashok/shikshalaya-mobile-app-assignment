import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/payment/presentation/view_model/payment_bloc.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/common/common_snackbar.dart';
import '../../../payment/presentation/view/khalti_screen.dart';
import '../view_model/bloc/course_bloc.dart';
import '../../domain/entity/course_entity.dart';

class CourseDetailPage extends StatefulWidget {
  final String courseId;
  const CourseDetailPage({super.key, required this.courseId});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late FlickManager flickManager;
  bool? isEnrolled =true; // Static enrollment status

  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(CheckEnrollmentEvent(widget.courseId));
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    String videoUrl =
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

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
        body: BlocListener<CourseBloc, CourseState>(
          listener: (context, state) {
            if (state is EnrollmentCheckedState) {
              setState(() {
                isEnrolled =
                    state.isEnrolled; // ✅ Safely update isEnrolled here
              });
            }
          },
          child: BlocBuilder<CourseBloc, CourseState>(
            builder: (context, state) {
              print("Current state: $state"); // Debugging output

              if (state is CourseLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is CourseError) {
                return Center(child: Text("Error: ${state.message}"));
              } else if (state is CourseLoaded) {
                final course = state.course;
                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: FlickVideoPlayer(flickManager: flickManager),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          OverviewTab(course: course),
                          LessonsTab(
                              course: course,
                              isEnrolled:
                                  isEnrolled ?? false), // ✅ Updated dynamically
                          ReviewsTab(),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Center(child: Text(""));
            },
          ),
        ),
        bottomNavigationBar: isEnrolled ?? false
            ? null
            : BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseLoaded) {
              final course = state.course; // ✅ Fetch course from state
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    context.read<CourseBloc>().add(
                      NavigateKhaltiDemoEvent(
                        context: context,
                        course: course, // Pass course ID
                      ),
                    );
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => const KhaltiSDKDemo()),
                    // );
                  },
                  child: Text(
                    'GET ENROLL',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }
            return SizedBox(); // If course data isn't available, return an empty widget
          },
        ),
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  final CourseEntity course;
  const OverviewTab({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('By ${course.instructorName}'),
          SizedBox(height: 8),
          Text(
            '${course.category} | ${course.level} | ${course.primaryLanguage}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            course.description,
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
              InfoBox(
                  icon: Icons.people,
                  text: '${course.students.length} Enrolled'),
              InfoBox(
                  icon: Icons.video_library,
                  text: '${course.curriculum.length} Lectures'),
            ],
          ),
        ],
      ),
    );
  }
}

class LessonsTab extends StatelessWidget {
  final CourseEntity course;
  final bool isEnrolled;

  const LessonsTab({super.key, required this.course, required this.isEnrolled});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: course.curriculum.length,
      itemBuilder: (context, index) {
        final lecture = course.curriculum[index];
        final isLocked = !lecture.freePreview &&
            !isEnrolled; // Lock if not preview and not enrolled

        // ✅ Ensure video URL starts with HTTPS
        final secureVideoUrl = lecture.videoUrl.startsWith('http:')
            ? lecture.videoUrl.replaceFirst('http:', 'https:')
            : lecture.videoUrl;

        return GestureDetector(
          onTap: () {
            if (isLocked) {
              showMySnackBar(
                context: context,
                message: "Access restricted! Enroll to continue learning. 📚",
                color: Colors.deepOrange,
              );
            } else {
              // ✅ Pass secure video URL to the Bloc if unlocked
              context.read<CourseBloc>().add(
                    NavigateToVideoPlayerEvent(
                      context: context,
                      videoUrl: secureVideoUrl, // ✅ Fixed URL
                    ),
                  );
            }
          },
          child: Card(
            elevation: isLocked ? 1 : 4, // More elevation for unlocked videos
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  color: isLocked ? Colors.grey : Colors.blue, width: 1),
            ),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isLocked ? Colors.grey[300] : Colors.white,
                  ),
                  child: Row(
                    children: [
                      // 🎥 Video Icon to indicate it's a playable video
                      Icon(
                        Icons.play_circle_fill,
                        color: isLocked ? Colors.grey : Colors.blueAccent,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          lecture.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isLocked ? Colors.grey[700] : Colors.black,
                          ),
                        ),
                      ),
                      if (isLocked)
                        const Icon(Icons.lock,
                            color: Colors.red), // Show lock icon if restricted
                    ],
                  ),
                ),

                // 🔒 Overlay effect for locked videos
                if (isLocked)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3), // Dark overlay
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
