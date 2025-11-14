import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/tab_switcher_controller.dart';

class TabSwitcherWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tabItems;
  final String? controllerTag;

  const TabSwitcherWidget({
    super.key,
    required this.tabItems,
    this.controllerTag,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabSwitcherController(), tag: controllerTag);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.primary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(1.5),
              child: Row(
                children: List.generate(tabItems.length, (i) {
                  return Expanded(
                    child: Obx(() {
                      final selected = controller.selectedIndex.value == i;
                      return GestureDetector(
                        onTap: () => controller.switchTab(i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? colorScheme.outlineVariant
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tabItems[i]['label'],
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: selected
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Obx(
                () => tabItems[controller.selectedIndex.value]['content'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
