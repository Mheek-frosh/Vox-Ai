import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import '../controllers/voice_controller.dart';
import '../theme/app_colors.dart';

class VoiceOverlay extends StatelessWidget {
  VoiceOverlay({super.key});
  final _voice = Get.find<VoiceController>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Deep Blur Surface
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.black.withOpacity(0.85)),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 100),
                // Top AI Hub
                FadeInDown(
                  child: Center(
                    child: Lottie.network(
                      'https://assets5.lottiefiles.com/packages/lf20_6n9mruy6.json', // Pulse
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),

                const Spacer(),

                // Active Transcript
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Obx(
                    () => FadeIn(
                      key: ValueKey(_voice.lastWords.value),
                      child: Text(
                        _voice.lastWords.value.isEmpty
                            ? "NEURAL LINK ESTABLISHED..."
                            : _voice.lastWords.value.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Lottie Voice Wave
                Lottie.network(
                  'https://assets4.lottiefiles.com/packages/lf20_f7h6vpxj.json', // Wave animation
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                const Spacer(),

                // Controls
                FadeInUp(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _voice.stopListening(),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                            color: AppColors.primary.withOpacity(0.05),
                          ),
                          child: const Icon(
                            Icons.stop_rounded,
                            color: AppColors.primary,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'END SESSION',
                        style: TextStyle(
                          color: AppColors.primary.withOpacity(0.5),
                          fontSize: 10,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
