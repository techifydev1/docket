import 'package:docket/features/home/screens/home_screen.dart';
import 'package:docket/features/onboarding/screens/first_screen.dart';
import 'package:docket/features/onboarding/screens/second_screen.dart';
import 'package:docket/features/onboarding/screens/third_screen.dart';

import 'package:docket/features/onboarding/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController pageController = PageController();
  int currentScreen = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _goBack() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .center,
            children: [
              TopBar(
                currentScreen: currentScreen,
                onBack: currentScreen > 0 ? _goBack : null,
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => currentScreen = index);
                  },
                  children: [
                    FirstScreen(pageController: pageController),
                    SecondScreen(pageController: pageController),
                    ThirdScreen(onComplete: _completeOnboarding),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
