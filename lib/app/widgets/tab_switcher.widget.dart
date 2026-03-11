import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A reusable two-tab switcher backed by ForUI FTabs.
class TabSwitcherWidget extends StatelessWidget {
  final String controllerTag;

  /// Each item: {'label': String, 'content': Widget}
  final List<Map<String, dynamic>> tabItems;

  const TabSwitcherWidget({
    super.key,
    required this.controllerTag,
    required this.tabItems,
  });

  @override
  Widget build(BuildContext context) {
    return FTabs(
      children: tabItems
          .map(
            (item) => FTabEntry(
              label: Text(item['label'] as String),
              child: item['content'] as Widget,
            ),
          )
          .toList(),
    );
  }
}
