import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:jihati/app/modules/jihati/controllers/jihati_controller.dart';
import 'package:jihati/app/modules/jihati/views/jihati_view.dart';
import 'package:jihati/app/modules/quran/controllers/quran_controller.dart';
import 'package:jihati/app/modules/quran/views/quran_view.dart';
import 'package:jihati/app/modules/setting/views/setting_view.dart';

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
}
