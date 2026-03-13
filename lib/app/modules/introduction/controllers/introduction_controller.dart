import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jihati/app/routes/app_pages.dart';

class IntroductionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ── Text animations ─────────────────────────────────────────────
  late AnimationController fadeController;
  late AnimationController scaleController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  // ── Blur overlay ────────────────────────────────────────────────
  late AnimationController blurController;
  late Animation<double> blurAnimation;

  // ── Subtitle slide-up ───────────────────────────────────────────
  late AnimationController subtitleController;
  late Animation<double> subtitleFade;
  late Animation<Offset> subtitleSlide;

  // ── Glow ring pulse ─────────────────────────────────────────────
  late AnimationController glowController;
  late Animation<double> glowScale;
  late Animation<double> glowOpacity;

  final showText    = false.obs;
  final showSubtitle = false.obs;

  late BuildContext context;
  late TickerProvider vsync;

  void setup({required BuildContext ctx, required TickerProvider ticker}) {
    context = ctx;
    vsync   = ticker;
    _initAnimations();
  }

  void _initAnimations() {
    // Blur
    blurController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: vsync,
    );
    blurAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(parent: blurController, curve: Curves.easeInOut),
    );

    // Main title fade + scale
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: vsync,
    );
    scaleController = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: vsync,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: fadeController, curve: Curves.easeOut),
    );
    scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.easeOutBack),
    );

    // Subtitle slide-up
    subtitleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
    subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: subtitleController, curve: Curves.easeOut),
    );
    subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: subtitleController, curve: Curves.easeOutCubic),
    );

    // Glow ring pulse (repeats)
    glowController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: vsync,
    );
    glowScale = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: glowController, curve: Curves.easeInOut),
    );
    glowOpacity = Tween<double>(begin: 0.35, end: 0.0).animate(
      CurvedAnimation(parent: glowController, curve: Curves.easeIn),
    );
  }

  void start() async {
    // Phase 1 — blur in
    await Future.delayed(const Duration(milliseconds: 400));
    blurController.forward();

    // Phase 2 — show main title
    await Future.delayed(const Duration(milliseconds: 1600));
    showText.value = true;
    fadeController.forward();
    scaleController.forward();

    // Phase 3 — glow ring starts pulsing
    await Future.delayed(const Duration(milliseconds: 400));
    glowController.repeat(reverse: true);

    // Phase 4 — subtitle slides up
    await Future.delayed(const Duration(milliseconds: 500));
    showSubtitle.value = true;
    subtitleController.forward();

    // Phase 5 — navigate
    await Future.delayed(const Duration(milliseconds: 2400));
    if (context.mounted) {
      final storage      = GetStorage();
      final isOnboarding = storage.read('onboarding');
      if (isOnboarding == true) {
        Get.offAllNamed(Routes.mainNavigation);
      } else {
        Get.offAllNamed(Routes.onboarding);
      }
    }
  }

  @override
  void onClose() {
    fadeController.dispose();
    scaleController.dispose();
    blurController.dispose();
    subtitleController.dispose();
    glowController.dispose();
    super.onClose();
  }
}
