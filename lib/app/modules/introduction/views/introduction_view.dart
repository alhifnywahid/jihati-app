import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends StatefulWidget {
  const IntroductionView({super.key});

  @override
  State<IntroductionView> createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView>
    with TickerProviderStateMixin {
  late final IntroductionController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<IntroductionController>();
    controller.setup(ctx: context, ticker: this);
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    const image = 'assets/images/ilustration/splashscreen.JPG';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background image (unchanged) ───────────────────────
          Image.asset(image, fit: BoxFit.cover),

          // ── Blur overlay ───────────────────────────────────────
          AnimatedBuilder(
            animation: controller.blurController,
            builder: (_, _) => Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: controller.blurAnimation.value,
                  sigmaY: controller.blurAnimation.value,
                ),
                child: Container(
                  color: Colors.black.withAlpha(
                    (60 * (controller.blurAnimation.value / 5.0)).round(),
                  ),
                ),
              ),
            ),
          ),

          // ── Main content ───────────────────────────────────────
          Obx(() => controller.showText.value
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Glow ring + title stacked
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulsing glow ring
                          AnimatedBuilder(
                            animation: controller.glowController,
                            builder: (_, _) => Transform.scale(
                              scale: controller.glowScale.value,
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withAlpha(
                                        (controller.glowOpacity.value * 255)
                                            .round(),
                                      ),
                                      blurRadius: 60,
                                      spreadRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Main Arabic title
                          AnimatedBuilder(
                            animation: Listenable.merge([
                              controller.fadeController,
                              controller.scaleController,
                            ]),
                            builder: (_, _) => Transform.scale(
                              scale: controller.scaleAnimation.value,
                              child: Opacity(
                                opacity: controller.fadeAnimation.value,
                                child: const Text(
                                  'جِهَتِي',
                                  style: TextStyle(
                                    fontFamily: 'OmarNaskh',
                                    fontSize: 86,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black45,
                                        blurRadius: 16,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Subtitle slide-up + fade
                      Obx(() => controller.showSubtitle.value
                          ? AnimatedBuilder(
                              animation: controller.subtitleController,
                              builder: (_, _) => FractionalTranslation(
                                translation: controller.subtitleSlide.value,
                                child: Opacity(
                                  opacity: controller.subtitleFade.value,
                                  child: Column(
                                    children: [
                                      // Decorative divider
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 1,
                                            color:
                                                Colors.white.withAlpha(120),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.white.withAlpha(180),
                                            ),
                                          ),
                                          Container(
                                            width: 40,
                                            height: 1,
                                            color:
                                                Colors.white.withAlpha(120),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                      'Raudlatul Ulum Arrahmaniyah',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withAlpha(210),
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink()),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
