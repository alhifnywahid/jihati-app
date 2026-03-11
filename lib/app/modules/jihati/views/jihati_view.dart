import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/routes/app_pages.dart';
import 'package:jihati/app/widgets/custom_search_bar.widget.dart';
import 'package:jihati/app/widgets/jihati_list_view.widget.dart';
import 'package:jihati/app/widgets/no_result.widget.dart';

import '../controllers/jihati_controller.dart';

class JihatiView extends GetView<JihatiController> {
  const JihatiView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final searchFocusNode = FocusNode();
    final ThemeController themeC = Get.find();

    return FScaffold(
      header: FHeader(
        title: const Text('Jihati'),
        suffixes: [
          Obx(
            () => FHeaderAction(
              icon: Icon(themeC.currentThemeIcon),
              onPress: () => themeC.cycleTheme(),
            ),
          ),
          FHeaderAction(
            icon: const Icon(FIcons.history),
            onPress: () => Get.toNamed(Routes.history),
          ),
          FHeaderAction(
            icon: const Icon(FIcons.bookmark),
            onPress: () => Get.toNamed(Routes.bookmark),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => searchFocusNode.unfocus(),
        child: Column(
          children: [
            CustomSearchBarWidget(
              text: 'Cari...',
              searchController: searchController,
              focusNode: searchFocusNode,
              onChange: controller.filterContents,
            ),
            Expanded(
              child: Obx(() {
                if (controller.contents.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredContents.isEmpty &&
                    controller.searchQuery.isNotEmpty) {
                  return const NoResultWidget(
                    text: 'Tidak ada jihati yang cocok!',
                  );
                }
                return JihatiListViewWidget(
                  items: controller.filteredContents,
                  onItemTap: (item) {
                    searchFocusNode.unfocus();
                    final index = controller.filteredContents.indexOf(item);
                    Get.toNamed(
                      Routes.jihatiDetail,
                      arguments: {
                        'id': item.id,
                        'arabicTitle': item.titleArabic,
                        'latinTitle': item.titleLatin,
                        'listItems': controller.filteredContents,
                        'currentIndex': index,
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
