import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ReadingPreferenceController extends GetxController {
  final box = GetStorage();

  final arabicFontSize = 28.0.obs;
  final latinFontSize = 18.0.obs;
  final showLatin = true.obs;
  final showTranslation = true.obs;

  static const arabicFontSizeKey = 'pref_arabic_font_size';
  static const latinFontSizeKey = 'pref_latin_font_size';
  static const showLatinKey = 'pref_show_latin';
  static const showTranslationKey = 'pref_show_translation';

  @override
  void onInit() {
    arabicFontSize.value = box.read(arabicFontSizeKey) ?? 28;
    latinFontSize.value = box.read(latinFontSizeKey) ?? 18;
    showLatin.value = box.read(showLatinKey) ?? true;
    showTranslation.value = box.read(showTranslationKey) ?? true;
    super.onInit();
  }

  void updateArabicFontSize(double value) {
    arabicFontSize.value = value;
    box.write(arabicFontSizeKey, value);
  }

  void increaseArabicFontSize() =>
      updateArabicFontSize((arabicFontSize.value + 2).clamp(16, 35));

  void decreaseArabicFontSize() =>
      updateArabicFontSize((arabicFontSize.value - 2).clamp(16, 35));
}
