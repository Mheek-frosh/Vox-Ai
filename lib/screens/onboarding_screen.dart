import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Master Your World\nWith Voice",
      description:
          "Experience the next generation of AI assistance. Control your digital life with the power of your voice.",
      lottieUrl: "https://assets10.lottiefiles.com/packages/lf20_myejig9p.json",
      gradient: [const Color(0xFFA855F7), const Color(0xFF7C3AED)],
    ),
    OnboardingData(
      title: "Neural Intelligence\nRedefined",
      description:
          "Advanced voice recognition and neural processing tailored to your unique linguistic patterns.",
      lottieUrl: "https://assets5.lottiefiles.com/packages/lf20_6n9mruy6.json",
      gradient: [const Color(0xFFD946EF), const Color(0xFFA855F7)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Background Gradient Depth
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [
                  _pages[_currentPage].gradient[0].withOpacity(0.1),
                  AppColors.darkBg,
                ],
              ),
            ),
          ),

          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final data = _pages[index];
              return Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    ZoomIn(
                      duration: const Duration(seconds: 1),
                      child: Lottie.network(
                        data.lottieUrl,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 60),
                    FadeInUp(
                      key: ValueKey("title_$index"),
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        data.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      key: ValueKey("desc_$index"),
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        data.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          height: 1.6,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
          ),

          // Navigation Bottom
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicators
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.primary
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                // Action Button
                FadeInRight(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Get.offAllNamed('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 10,
                      shadowColor: AppColors.primary.withOpacity(0.5),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? "AUTHORIZE" : "NEXT",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String lottieUrl;
  final List<Color> gradient;

  OnboardingData({
    required this.title,
    required this.description,
    required this.lottieUrl,
    required this.gradient,
  });
}
