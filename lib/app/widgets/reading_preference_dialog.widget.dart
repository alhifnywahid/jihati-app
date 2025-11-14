import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/reading_preference_controller.dart'; 

class ReadingPreferenceDialog extends GetView<ReadingPreferenceController> {
  const ReadingPreferenceDialog({super.key});

  static Future<void> show(BuildContext context) async {
    Get.lazyPut(() => ReadingPreferenceController());
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReadingPreferenceDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
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
                    const SizedBox(height: 16),
                    const Text(
                      'Ukuran Teks Arab',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: controller.decreaseArabicFontSize,
                        ),
                        Expanded(
                          child: Slider(
                            value: controller.arabicFontSize.value,
                            min: 16,
                            max: 35,
                            divisions: 16,
                            onChanged: controller.updateArabicFontSize,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: controller.increaseArabicFontSize,
                        ),
                      ],
                    ),
                    Center(
                      child: Text(
                        'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                        style: TextStyle(
                          fontFamily: 'LPMQ-IsepMisbah',
                          fontSize: controller.arabicFontSize.value,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
