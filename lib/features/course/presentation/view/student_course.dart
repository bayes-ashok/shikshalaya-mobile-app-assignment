import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/bloc/course_bloc.dart';
import '../widget/course_card_ui.dart';

class CourseGridScreen extends StatefulWidget {
  const CourseGridScreen({super.key});

  @override
  _CourseGridScreenState createState() => _CourseGridScreenState();
}

class _CourseGridScreenState extends State<CourseGridScreen> {
  @override
  void initState() {
    super.initState();

    // Dispatch FetchStudentCoursesEvent when screen is created
    Future.microtask(() {
      context.read<CourseBloc>().add(FetchStudentCoursesEvent());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Learning"),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity,
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
        child: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CourseError) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.red)));
            }

            if (state is StudentCoursesLoaded) {
              if (state.courses.isEmpty) {
                return const Center(child: Text("No courses available"));
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
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
                  itemCount: state.courses.length,
                  itemBuilder: (context, index) {
                    final course = state.courses[index];
                    return GestureDetector(
                      onTap: () {
                        context
                            .read<CourseBloc>()
                            .add(FetchCourseByIdEvent(course.courseId));
                      },
                      child: CourseCard(course: course),
                    );
                  },
                ),
              );
            }

            return const Center(child: Text("Failed to load courses"));
          },
        ),
      ),
    );
  }
}
