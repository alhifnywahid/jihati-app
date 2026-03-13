import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:jihati/app/modules/jihati/controllers/jihati_controller.dart';
import 'package:jihati/app/modules/jihati/views/jihati_view.dart';
import 'package:jihati/app/modules/quran/controllers/quran_controller.dart';
import 'package:jihati/app/modules/quran/views/quran_view.dart';
import 'package:jihati/app/modules/setting/views/setting_view.dart';
import 'package:jihati/utils/logger.util.dart';

class MainNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  final menu = [
    {
      "title": "Jihati",
      "icon": Icon(LucideIcons.book_open),
      "builder": () => JihatiView(),
    },
    {
      "title": "Quran",
      "icon": Icon(LucideIcons.book_open_text),
      "builder": () => QuranView(),
    },
    {
      "title": "Pengaturan",
      "icon": Icon(LucideIcons.settings),
      "builder": () => SettingView(),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Delay slightly so main UI renders first before checking update
    Future.delayed(const Duration(seconds: 2), _checkForUpdate);
  }

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
    if (index == 0) {
      Get.find<JihatiController>().resetSearch();
    } else if (index == 1) {
      Get.find<QuranController>().resetSearch();
    }
  }

  Map<String, dynamic> getMenu() {
    return menu[selectedIndex.value];
  }

  /// Check Google Play for available update.
  /// Silently fails on non-Android or non-Play Store (e.g. debug) environments.
  Future<void> _checkForUpdate() async {
    // in_app_update is Android-only
    if (!Platform.isAndroid) return;

    try {
      final AppUpdateInfo info = await InAppUpdate.checkForUpdate();

      // Case 1: Update was previously downloaded — install it now
      if (info.installStatus == InstallStatus.downloaded) {
        await InAppUpdate.completeFlexibleUpdate();
        return;
      }

      // Case 2: New update available from Play Store
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        // Flexible update: user can keep using the app while it downloads
        await InAppUpdate.startFlexibleUpdate();
      }
    } catch (e) {
      // Gracefully ignore all errors:
      //  - Not installed from Play Store (debug/sideload)
      //  - No internet connection
      //  - Play Store not available on device
      logger.d('In-app update check skipped: $e');
    }
  }
}
