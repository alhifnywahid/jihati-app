import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingController extends GetxController {
  final themeController = Get.find<ThemeController>();

  bool get isDarkMode => themeController.currentTheme == ThemeMode.dark;

  List<Map<String, dynamic>> get sections => [
    {
      "title": "Umum",
      "items": [
        {
          "title": "Tema",
          "icon": themeController.currentThemeIcon,
          "isSwitch": true,
          "value": isDarkMode,
          "onChanged": (_) => themeController.changeTheme(),
        },
        {
          "title": "Tersimpan",
          "icon": LucideIcons.bookmark_check,
          "onTap": () => Get.toNamed(Routes.BOOKMARK),
        },
        {
          "title": "Riwayat",
          "icon": Icons.history_outlined,
          "onTap": () => Get.toNamed(Routes.HISTORY),
        },
      ],
    },
    {
      "title": "Tentang Aplikasi",
      "items": [
        {
          "title": "Tentang Kami",
          "icon": Icons.person_outline,
          "onTap": () => Get.toNamed(Routes.ABOUTME),
        },
        // {
        //   "title": "Bagikan Aplikasi",
        //   "icon": Icons.share_outlined,
        //   "onTap": () {
        //     Share.share(
        //       'Coba aplikasi Jihati - Amaliyah santri Raudlatul \'Ulum Arrahmaniyah\n\n📱 Download di: https://play.google.com/store/apps/details?id=com.rua.jihati&hl=id',
        //       subject: 'Jihati - Amaliyah santri RUA',
        //     );
        //   },
        // },
        {
          "title": "Beri Masukan",
          "icon": Icons.feedback_outlined,
          "onTap": () => _launchFeedbackForm(),
        },
        {
          "title": "Media Sosial Kami",
          "icon": Icons.people_outline,
          "onTap": () => Get.toNamed(Routes.ACCOUNTME),
        },
      ],
    },
  ];

  void _launchFeedbackForm() async {
    const url = 'https://tally.so/r/wv6GeQ';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Tidak dapat membuka form masukan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
