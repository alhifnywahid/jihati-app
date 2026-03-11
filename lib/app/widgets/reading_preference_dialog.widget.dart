import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/reading_preference_controller.dart';

class ReadingPreferenceDialog extends GetView<ReadingPreferenceController> {
  const ReadingPreferenceDialog({super.key});

  static Future<void> show(BuildContext context) async {
    Get.lazyPut(() => ReadingPreferenceController());
    await showFSheet(
      context: context,
      side: FLayout.btt,
      builder: (context) => const ReadingPreferenceDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(FIcons.arrowLeft),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Preferensi Membaca',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Ukuran Teks Arab',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: controller.decreaseArabicFontSize,
                    icon: const Icon(FIcons.minus),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${controller.arabicFontSize.value.toInt()}px',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: controller.increaseArabicFontSize,
                    icon: const Icon(FIcons.plus),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                  style: TextStyle(
                    fontFamily: 'LPMQ-IsepMisbah',
                    fontSize: controller.arabicFontSize.value,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
