import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => PageView.builder(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.pages.length,
                  onPageChanged: (index) =>
                      controller.currentPage.value = index,
                  itemBuilder: (_, index) {
                    final model = controller.pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              model.imageUrl,
                              width: 320,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              model.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: Text(
                                model.description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Dot indicator
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(controller.pages.length, (index) {
                  final isActive = index == controller.currentPage.value;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: isActive ? 28 : 8,
                    height: 8,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              final page = controller.currentPage.value;
              final label = page == controller.pages.length - 1
                  ? controller.textFinish.value
                  : 'Lanjut';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: FButton(
                  onPress: () => controller.handleNextButton(context),
                  child: Text(label, style: const TextStyle(fontSize: 16)),
                ),
              );
            }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
