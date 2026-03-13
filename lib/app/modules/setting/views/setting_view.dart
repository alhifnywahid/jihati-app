import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/widgets/green_header.widget.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: greenAppBar(context: context, title: 'Pengaturan'),
      body: Obx(() => ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: controller.sections.map((section) {
          final isAbout = (section['title'] as String) == 'Tentang Aplikasi';
          return _SettingSection(
            title: section['title'] as String,
            items: (section['items'] as List).cast<Map<String, dynamic>>(),
            isDark: isDark,
            trailingLabel: isAbout
                ? 'v${controller.appVersion.value}'
                : null,
          );
        }).toList(),
      )),
    );
  }
}

// ---------------------------------------------------------------------------
// App identity header card (gradient)

// ---------------------------------------------------------------------------
// Setting section
// ---------------------------------------------------------------------------
class _SettingSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final bool isDark;
  final String? trailingLabel;

  const _SettingSection({
    required this.title,
    required this.items,
    required this.isDark,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor =
        isDark ? const Color(0xFF6B7280) : const Color(0xFF9E9E9E);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Row(
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: labelColor,
                    letterSpacing: 1.2,
                  ),
                ),
                if (trailingLabel != null) ...
                  [
                    const Spacer(),
                    Text(
                      trailingLabel!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: labelColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
              ],
            ),
          ),
          _PremiumTileGroup(items: items, isDark: isDark),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Rounded card group
// ---------------------------------------------------------------------------
class _PremiumTileGroup extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final bool isDark;
  const _PremiumTileGroup({required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E2229) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2C3040) : const Color(0xFFEEEEEE);
    final dividerColor =
        isDark ? const Color(0xFF252B36) : const Color(0xFFF2F2F2);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final isLast = i == items.length - 1;
          return Column(
            children: [
              _PremiumTile(item: items[i], isDark: isDark),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: dividerColor,
                  indent: 56,
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual tile
// ---------------------------------------------------------------------------
class _PremiumTile extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isDark;
  const _PremiumTile({required this.item, required this.isDark});

  @override
  State<_PremiumTile> createState() => _PremiumTileState();
}

class _PremiumTileState extends State<_PremiumTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isDark = widget.isDark;
    final isSwitch = item['isSwitch'] == true;
    final subtitle = item['subtitle'] as String?;
    final icon = item['icon'] as IconData;
    final title = item['title'] as String;
    final onTap = item['onTap'];

    final iconBg = const Color(0xFF1A3A1F).withAlpha(isDark ? 200 : 40);
    final pressedBg =
        isDark ? const Color(0xFF242B35) : const Color(0xFFF5F5F5);
    final titleColor =
        isDark ? const Color(0xFFDDE2EA) : const Color(0xFF1A1A1A);
    final subtitleColor =
        isDark ? const Color(0xFF8B9099) : const Color(0xFF757575);
    final trailColor =
        isDark ? const Color(0xFF4A5568) : const Color(0xFFBDBDBD);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        if (!isSwitch) setState(() => _pressed = true);
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!isSwitch && onTap != null) {
          try {
            (onTap as Function)(context);
          } catch (_) {
            (onTap as Function)();
          }
        }
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: _pressed ? pressedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                          fontSize: 12, color: subtitleColor),
                    ),
                  ],
                ],
              ),
            ),
            if (isSwitch)
              FSwitch(
                value: item['value'] as bool? ?? false,
                onChange: (v) {
                  if (item['onChanged'] != null) {
                    (item['onChanged'] as Function)(v);
                  }
                },
              )
            else
              Icon(LucideIcons.chevron_right,
                  size: 16, color: trailColor),
          ],
        ),
      ),
    );
  }
}
