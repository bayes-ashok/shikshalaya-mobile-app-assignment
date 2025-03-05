import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/app/di/di.dart';
import 'package:shikshalaya/features/auth/presentation/view/login_view.dart';

import '../view_model/login/login_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome to Shikshalaya',
      'description':
          'Your ultimate destination for Loksewa preparation. Learn from top institutes and get access to exclusive content.',
      'image': 'assets/icons/LOGO-nobg.png',
    },
    {
      'title': 'Expert Video Lectures',
      'description':
          'Master every topic with detailed video lectures from experienced educators and leading institutes.',
      'image': 'assets/images/onboarding2.jpg',
    },
    {
      'title': 'Practice Makes Perfect',
      'description':
          'Take regular tests to evaluate your progress and improve your preparation strategy.',
      'image': 'assets/images/onboarding3.jpg',
    },
  ];

  void _onSkip() {
    _pageController.animateToPage(
      _onboardingData.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _onNext() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    // Navigate directly to the LoginScreen and provide the LoginBloc
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: getIt<LoginBloc>(), // Provide the LoginBloc instance here
          child: LoginView(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                return _buildOnboardingSlide(
                  _onboardingData[index]['title']!,
                  _onboardingData[index]['description']!,
                  _onboardingData[index]['image']!,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _onSkip,
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage == _onboardingData.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => _buildDot(index),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingSlide(String title, String description, String image) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250), // Replace with your asset images
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
