// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    OnboardingPage(
      title: 'Welcome to the App',
      description: 'This is the first onboarding screen.',
      image: 'assets/onboarding1.png', // Add your image asset
    ),
    OnboardingPage(
      title: 'Explore Features',
      description: 'Discover all the amazing features of the app.',
      image: 'assets/onboarding2.png', // Add your image asset
    ),
    OnboardingPage(
      title: 'Get Started',
      description: 'Start using the app now!',
      image: 'assets/onboarding3.png', // Add your image asset
    ),
  ];

  void _onNextPressed() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        // ignore: prefer_const_constructors
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstTime', false); // Mark onboarding as completed

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) => _pages[index],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(_pages.length - 1);
                  },
                  child: Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: _onNextPressed,
                  child: Text(
                      _currentPage == _pages.length - 1 ? 'Start' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  OnboardingPage(
      {required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 200), // Add your image asset
        const SizedBox(height: 20),
        Text(title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(description, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
