import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/routes/app_pages.dart';
import 'package:jihati/app/widgets/theme_sheet.widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingController extends GetxController {
  final themeController = Get.find<ThemeController>();
  final appVersion = '...'.obs;

  bool get isDarkMode => themeController.currentTheme == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion.value = info.version;
  }

  List<Map<String, dynamic>> get sections => [
    {
      'title': 'Umum',
      'items': [
        {
          'title': 'Tema',
          'subtitle': themeController.currentThemeLabel,
          'icon': themeController.currentThemeIcon,
          'isSwitch': false,
          'onTap': (context) => ThemeSheetDialog.show(context),
        },
        {
          'title': 'Tersimpan',
          'icon': LucideIcons.bookmark_check,
          'onTap': () => Get.toNamed(Routes.bookmark),
        },
        {
          'title': 'Riwayat',
          'icon': Icons.history_outlined,
          'onTap': () => Get.toNamed(Routes.history),
        },
      ],
    },
    {
      'title': 'Tentang Aplikasi',
      'items': [
        {
          'title': 'Tentang Kami',
          'icon': Icons.person_outline,
          'onTap': () => Get.toNamed(Routes.aboutme),
        },
        {
          'title': 'Beri Masukan',
          'icon': Icons.feedback_outlined,
          'onTap': () => _launchFeedbackForm(),
        },
        {
          'title': 'Media Sosial Kami',
          'icon': Icons.people_outline,
          'onTap': () => Get.toNamed(Routes.accountme),
        },
        {
          'title': 'Periksa Pembaruan',
          'icon': LucideIcons.refresh_cw,
          'onTap': () => _checkForUpdate(),
        },
        {
          'title': 'Bagikan Aplikasi',
          'icon': LucideIcons.share_2,
          'onTap': () => _shareApp(),
        },
      ],
    },
  ];

  void _launchFeedbackForm() async {
    const url = 'https://tally.so/r/wv6GeQ';
    final uri = Uri.parse(url);
    final ctx = Get.context;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (ctx != null && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka form masukan'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  static const _packageId = 'com.gopretstudio.jihati';
  static const _storeUrl =
      'https://play.google.com/store/apps/details?id=$_packageId';

  void _checkForUpdate() async {
    final uri = Uri.parse(_storeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareApp() {
    const message =
        'Assalamu\'alaikum! 🌙\n\n'
        'Saya menemukan aplikasi yang sangat bermanfaat untuk meningkatkan '
        'kualitas ibadah kita sehari-hari.\n\n'
        '*Jihati* — Panduan Lengkap Keislaman\n'
        '📖 Al-Quran digital lengkap\n'
        '✨ Panduan bacaan & doa harian\n'
        '🔖 Fitur simpan & riwayat bacaan\n\n'
        'Yuk download sekarang, gratis! 👇\n'
        '$_storeUrl';

    SharePlus.instance.share(ShareParams(text: message));
  }
}
