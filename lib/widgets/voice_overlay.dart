import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../controllers/voice_controller.dart';
import '../theme/app_colors.dart';

class VoiceOverlay extends StatelessWidget {
  final VoiceController voiceController = Get.find<VoiceController>();

  VoiceOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.85),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInDown(
            child: Text(
              "Vox AI is listening...",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Waveform placeholder - In a real app we'd use a CustomPainter or Lottie
          Lottie.network(
            'https://assets9.lottiefiles.com/packages/lf20_S69rU8.json', // Voice waveform lottie
            height: 200,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(10, (index) => _buildBar(index)),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Obx(
            () => FadeInUp(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  voiceController.lastWords.value.isEmpty
                      ? "Go ahead, I'm all ears"
                      : voiceController.lastWords.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          IconButton(
            onPressed: () => voiceController.stopListening(),
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.error),
              ),
              child: const Icon(Icons.close, color: AppColors.error, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 10, end: 100),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: value,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}
