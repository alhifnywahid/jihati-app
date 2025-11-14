import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
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
    searchController.text = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jihati'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.history),
            color: Colors.white,
            onPressed: () => Get.toNamed(Routes.HISTORY),
          ),
          IconButton(
            icon: const Icon(LucideIcons.bookmark),
            color: Colors.white,
            onPressed: () => Get.toNamed(Routes.BOOKMARK),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.contents.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return GestureDetector(
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
                child:
                    controller.filteredContents.isEmpty &&
                        controller.searchQuery.isNotEmpty
                    ? NoResultWidget(text: "Tidak ada hasil pencarian!")
                    : JihatiListViewWidget(
                        items: controller.filteredContents,
                        onItemTap: (item) {
                          searchFocusNode.unfocus();
                          final index = controller.filteredContents.indexOf(
                            item,
                          );
                          Get.toNamed(
                            Routes.JIHATI_DETAIL,
                            arguments: {
                              'id': item.id,
                              'arabicTitle': item.titleArabic,
                              'latinTitle': item.titleLatin,
                              'listItems': controller.filteredContents,
                              'currentIndex': index,
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
