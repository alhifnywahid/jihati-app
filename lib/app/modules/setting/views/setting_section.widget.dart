import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SettingSectionWidget extends StatelessWidget {
  final Map section;
  const SettingSectionWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final items = section['items'] as List;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              section['title'] as String,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          FTileGroup(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSwitch = item['isSwitch'] == true;
              final subtitle = item['subtitle'] as String?;
              final onTap = item['onTap'];

              return FTile(
                prefix: Icon(item['icon'] as IconData),
                title: Text(item['title'] as String),
                subtitle: subtitle != null ? Text(subtitle) : null,
                suffix: isSwitch
                    ? FSwitch(
                        value: item['value'] as bool,
                        onChange: (v) {
                          if (item['onChanged'] != null) {
                            (item['onChanged'] as Function)(v);
                          }
                        },
                      )
                    : const Icon(FIcons.chevronRight),
                onPress: isSwitch
                    ? null
                    : onTap != null
                        ? () {
                            // support both onTap() and onTap(context)
                            try {
                              (onTap as Function)(context);
                            } catch (_) {
                              (onTap as Function)();
                            }
                          }
                        : null,
              );
            }),
          ),
        ],
      ),
    );
  }
}
