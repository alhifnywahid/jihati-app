import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jihati/app/routes/app_pages.dart';

class IntroductionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController fadeController;
  late AnimationController scaleController;
  late AnimationController blurController;

  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> blurAnimation;

  final showText = false.obs;
  late BuildContext context;
  late TickerProvider vsync;

  void setup({required BuildContext ctx, required TickerProvider ticker}) {
    context = ctx;
    vsync = ticker;
    _initAnimations();
  }

  void _initAnimations() {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );

    scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );

    blurController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: vsync,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeInOut));

    scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.elasticOut),
    );

    blurAnimation = Tween<double>(
      begin: 0.0,
      end: 6.0,
    ).animate(CurvedAnimation(parent: blurController, curve: Curves.easeInOut));
  }

  void start() async {
    await Future.delayed(const Duration(seconds: 1));
    blurController.forward();

    await Future.delayed(const Duration(seconds: 3));
    showText.value = true;

    fadeController.forward();
    scaleController.forward();

    await Future.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      final storage = GetStorage();
      final isOnboarding = storage.read("onboarding");
        // Get.offAllNamed(Routes.ONBOARDING);
      if (isOnboarding == true) {
        Get.offAllNamed(Routes.MAIN_NAVIGATION);
      } else {
        Get.offAllNamed(Routes.ONBOARDING);
      }
    }
  }

  @override
  void onClose() {
    fadeController.dispose();
    scaleController.dispose();
    blurController.dispose();
    super.onClose();
  }
}
