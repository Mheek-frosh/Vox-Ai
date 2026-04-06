import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import '../controllers/voice_controller.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/voice_overlay.dart';

/// The main dashboard screen of the Vox AI application.
///
/// This screen provides the user interface for interacting with the voice assistant,
/// viewing recent stats, triggering routines, and seeing the command history.
class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  final _voice = Get.put(VoiceController());
  final _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Background Aesthetic
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Bar
                _buildSliverAppBar(),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Assistant Avatar Section
                        _buildAssistantAvatar(),

                        const SizedBox(height: 32),
                        // Main Response Card
                        _buildResponseCard(),

                        const SizedBox(height: 32),
                        // Stats Overview
                        _buildStatsOverview(),

                        const SizedBox(height: 32),
                        // Quick Actions Grid
                        _buildQuickActionsTitle(),
                        const SizedBox(height: 16),
                        _buildQuickActionsGrid(),

                        const SizedBox(height: 32),
                        // History Section
                        _buildHistorySection(),

                        const SizedBox(height: 120), // Space for FAB
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Voice Overlay
          Obx(
            () => _voice.isListening.value
                ? VoiceOverlay()
                : const SizedBox.shrink(),
          ),

          // Bottom Voice FAB
          _buildVoiceFAB(),
        ],
      ),
    );
  }

  /// Builds the top app bar with greeting and settings icon.
  Widget _buildSliverAppBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Morning, ${_auth.currentUser?.fullName.split(" ")[0] ?? "User"}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Neural Link: Active',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Get.toNamed('/settings'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the animated avatar representing the voice assistant.
  /// The animation changes based on whether the assistant is currently listening.
  Widget _buildAssistantAvatar() {
    return FadeIn(
      duration: const Duration(seconds: 2),
      child: Center(
        child: Column(
          children: [
            Obx(
              () => Lottie.network(
                _voice.isListening.value
                    ? 'https://assets5.lottiefiles.com/packages/lf20_6n9mruy6.json' // Active
                    : 'https://assets2.lottiefiles.com/packages/lf20_T637D6.json', // Idle
                height: 150,
                width: 150,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.circle,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'VOX-CORE v1.0',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the central card that displays the assistant's textual response.
  Widget _buildResponseCard() {
    return FadeInUp(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Obx(
              () => Text(
                _voice.responseText.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('Efficiency', '98%', Icons.bolt_rounded),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatItem('Latency', '24ms', Icons.speed_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsTitle() {
    return FadeInLeft(
      child: Text(
        'Neural Routines',
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildActionTile(
          'Search Web',
          Icons.language_rounded,
          AppColors.primary,
        ),
        _buildActionTile(
          'Music Player',
          Icons.music_note_rounded,
          Colors.orange,
        ),
        _buildActionTile('Smart Home', Icons.home_max_rounded, Colors.blue),
        _buildActionTile(
          'Settings',
          Icons.settings_input_component_rounded,
          Colors.teal,
        ),
      ],
    );
  }

  Widget _buildActionTile(String title, IconData icon, Color color) {
    return FadeInUp(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a horizontal list displaying the user's past voice commands.
  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Neural Logs',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _voice.commandHistory.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    _voice.commandHistory[index],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the floating action button used to trigger voice listening manually.
  Widget _buildVoiceFAB() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: FadeInUp(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _voice.startListening(),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'TAP TO TRIGGER',
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
