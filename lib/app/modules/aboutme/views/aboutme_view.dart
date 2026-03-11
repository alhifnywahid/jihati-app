import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

import '../controllers/aboutme_controller.dart';

class AboutmeView extends GetView<AboutmeController> {
  const AboutmeView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Tentang Kami'),
        prefixes: [FHeaderAction.back(onPress: () => Get.back())],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            FCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PW FORMASI RUA Surabaya',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(controller.texts.length * 2 - 1, (i) {
                    if (i.isEven) {
                      return Text(
                        controller.texts[i ~/ 2],
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 15, height: 1.6),
                      );
                    } else {
                      return const SizedBox(height: 12);
                    }
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FCard(
              child: Center(
                child: Text(
                  '"Bersama kita mengaji, menjalani, dan mengabdi."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
