import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/routes/app_pages.dart';
import 'package:jihati/app/widgets/custom_search_bar.widget.dart';
import 'package:jihati/app/widgets/green_header.widget.dart';
import 'package:jihati/app/widgets/jihati_list_view.widget.dart';
import 'package:jihati/app/widgets/no_result.widget.dart';
import 'package:jihati/app/widgets/theme_sheet.widget.dart';

import '../controllers/jihati_controller.dart';

class JihatiView extends GetView<JihatiController> {
  const JihatiView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final searchFocusNode = FocusNode();
    final themeC = Get.find<ThemeController>();

    return Scaffold(
      appBar: greenAppBar(
        context: context,
        title: 'Jihati',
        actions: [
          Obx(() => FHeaderAction(
            icon: Icon(themeC.currentThemeIcon, color: Colors.white, size: 20),
            onPress: () => ThemeSheetDialog.show(context),
          )),
          FHeaderAction(
            icon: const Icon(FIcons.history, color: Colors.white, size: 20),
            onPress: () => Get.toNamed(Routes.history),
          ),
          FHeaderAction(
            icon: const Icon(FIcons.bookmark, color: Colors.white, size: 20),
            onPress: () => Get.toNamed(Routes.bookmark),
          ),
        ],
      ),
      body: GestureDetector(
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
