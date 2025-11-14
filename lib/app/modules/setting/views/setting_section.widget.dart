import 'package:flutter/material.dart';

class SettingSectionWidget extends StatelessWidget {
  final Map section;
  const SettingSectionWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = section['items'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            section['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF353535).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  ListTile(
                    leading: Icon(item["icon"]),
                    title: Text(item["title"]),
                    trailing: item["isSwitch"] == true
                        ? Switch(
                            value: item["value"],
                            onChanged: item["onChanged"],
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: item["onTap"],
                  ),
                  if (!isLast) const Divider(height: 1),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
