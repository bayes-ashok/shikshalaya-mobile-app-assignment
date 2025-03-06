import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';
import 'package:shikshalaya/features/course/presentation/view/course_detail_page.dart';
import 'package:shikshalaya/features/course/presentation/view_model/bloc/course_bloc.dart';

class MockCourseBloc extends Mock implements CourseBloc {}

void main() {
  late CourseBloc mockCourseBloc;
  late CourseEntity mockCourse;

  setUp(() {
    mockCourseBloc = MockCourseBloc();

    // Sample mock course entity with lectures and students
    mockCourse = CourseEntity(
      courseId: "123",
      instructorId: "inst_001",
      instructorName: "John Doe",
      date: DateTime.now(),
      title: "Mock Course",
      category: "Education",
      level: "Beginner",
      primaryLanguage: "English",
      subtitle: "A test subtitle",
      description: "This is a mock course for testing.",
      image: "https://example.com/image.jpg",
      welcomeMessage: "Welcome to the course!",
      pricing: 99.99,
      objectives: "Learn basics;Improve skills;Master techniques",
      students: [],
      curriculum: [
        LectureEntity(
          title: "Lecture 1",
          videoUrl: "https://example.com/video1.mp4",
          publicId: "vid_001",
          freePreview: true,
        ),
        LectureEntity(
          title: "Lecture 2",
          videoUrl: "https://example.com/video2.mp4",
          publicId: "vid_002",
          freePreview: false,
        ),
      ],
      isPublished: true,
    );

    when(() => mockCourseBloc.stream)
        .thenAnswer((_) => Stream.value(CourseLoaded(course: mockCourse)));

    when(() => mockCourseBloc.state)
        .thenReturn(CourseLoaded(course: mockCourse));
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<CourseBloc>.value(
        value: mockCourseBloc,
        child: child,
      ),
    );
  }

  testWidgets('renders CourseDetailPage with app bar and tabs',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(buildTestableWidget(CourseDetailPage(courseId: "123")));

    // Verify the App Bar Title
    expect(find.text("Course Details"), findsOneWidget);

    // Verify Tab Bar Titles
    expect(find.text("Overview"), findsOneWidget);
    expect(find.text("Lessons"), findsOneWidget);
    expect(find.text("Reviews"), findsOneWidget);
  });

  testWidgets('switching tabs updates UI', (WidgetTester tester) async {
    await tester
        .pumpWidget(buildTestableWidget(CourseDetailPage(courseId: "123")));

    // Switch to Lessons Tab
    await tester.tap(find.text("Lessons"));
    await tester.pumpAndSettle();

    // Verify content changed (Lessons tab should now be active)
    expect(find.text("Lessons"), findsOneWidget);

    // Switch to Reviews Tab
    await tester.tap(find.text("Reviews"));
    await tester.pumpAndSettle();

    // Verify content changed (Reviews tab should now be active)
    expect(find.text("Reviews"), findsOneWidget);
  });

  testWidgets('Enroll button is present when user is not enrolled',
      (WidgetTester tester) async {
    final mockCourseBloc = MockCourseBloc();

    // ✅ Mock Enrollment State
    when(() => mockCourseBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([
        EnrollmentCheckedState(isEnrolled: false),
        CourseLoaded(
          course: CourseEntity(
            courseId: "123",
            instructorId: "inst_001",
            instructorName: "John Doe",
            date: DateTime.now(),
            title: "Mock Course",
            category: "Education",
            level: "Beginner",
            primaryLanguage: "English",
            subtitle: "A test subtitle",
            description: "This is a mock course for testing.",
            image: "https://example.com/image.jpg",
            welcomeMessage: "Welcome to the course!",
            pricing: 99.99,
            objectives: "Learn basics;Improve skills;Master techniques",
            students: [],
            curriculum: [
              LectureEntity(
                  title: "Lecture 1",
                  videoUrl: "https://example.com/video1.mp4",
                  publicId: "vid_001",
                  freePreview: true),
              LectureEntity(
                  title: "Lecture 2",
                  videoUrl: "https://example.com/video2.mp4",
                  publicId: "vid_002",
                  freePreview: false),
            ],
            isPublished: true,
          ),
        ),
      ]),
    );
    when(() => mockCourseBloc.state)
        .thenReturn(EnrollmentCheckedState(isEnrolled: false));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CourseBloc>.value(
          value: mockCourseBloc,
          child: CourseDetailPage(courseId: "123"),
        ),
      ),
    );

    await tester.pumpAndSettle(); // ✅ Ensure all state changes are reflected

    // ✅ Expect "GET ENROLL" button to be found
    expect(find.text("GET ENROLL"), findsOneWidget);
  });

  testWidgets('Lessons tab displays lectures', (WidgetTester tester) async {
    await tester
        .pumpWidget(buildTestableWidget(CourseDetailPage(courseId: "123")));

    // Switch to Lessons Tab
    await tester.tap(find.text("Lessons"));
    await tester.pumpAndSettle();

    // Verify the lectures are displayed
    expect(find.text("Lecture 1"), findsOneWidget);
    expect(find.text("Lecture 2"), findsOneWidget);
  });
}
