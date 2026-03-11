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
          Image.asset(image, fit: BoxFit.cover),

          AnimatedBuilder(
            animation: controller.blurController,
            builder: (context, child) {
              return Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: controller.blurAnimation.value,
                    sigmaY: controller.blurAnimation.value,
                  ),
                  child: Container(
                    color: Colors.black.withValues(
                      alpha: 0.2 * (controller.blurAnimation.value / 6.0),
                    ),
                  ),
                ),
              );
            },
          ),

          Obx(
            () => controller.showText.value
                ? Center(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        controller.fadeController,
                        controller.scaleController,
                      ]),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: controller.scaleAnimation.value,
                          child: Opacity(
                            opacity: controller.fadeAnimation.value,
                            child: const Text(
                              'جِهَتِي',
                              style: TextStyle(
                                fontFamily: 'OmarNaskh',
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
