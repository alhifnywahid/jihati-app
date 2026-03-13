import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';

class ThemeSheetDialog {
  ThemeSheetDialog._();

  static void show(BuildContext context) {
    final themeC = Get.find<ThemeController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final sheetBg = isDark ? const Color(0xFF13151A) : Colors.white;
        final handleColor = isDark
            ? Colors.white.withAlpha(30)
            : Colors.grey.withAlpha(80);

        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
            border: isDark
                ? Border(
                    top: BorderSide(
                        color: Colors.white.withAlpha(12), width: 1))
                : null,
          ),
          padding: EdgeInsets.fromLTRB(
            20, 12, 20,
            MediaQuery.of(ctx).viewInsets.bottom + 36,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 28),
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Icon + Title
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A3A1F)
                      : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  LucideIcons.palette,
                  color: const Color(0xFF4CAF50),
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Pilih Tema',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFDDE2EA)
                      : const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tampilan akan langsung berubah sesuai pilihan Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      isDark ? const Color(0xFF6B7280) : const Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(height: 24),

              // Theme options
              Obx(() {
                final current = themeC.themeMode.value;
                return Column(
                  children: [
                    _ThemeOptionCard(
                      ctx: ctx,
                      themeC: themeC,
                      isDark: isDark,
                      icon: LucideIcons.sun,
                      iconBg: isDark
                          ? const Color(0xFF2A1F0A)
                          : const Color(0xFFFFF8E1),
                      iconColor: const Color(0xFFF59E0B),
                      title: 'Terang',
                      subtitle:
                          'Tampilan cerah untuk penggunaan siang hari',
                      mode: ThemeMode.light,
                      current: current,
                    ),
                    const SizedBox(height: 10),
                    _ThemeOptionCard(
                      ctx: ctx,
                      themeC: themeC,
                      isDark: isDark,
                      icon: LucideIcons.moon,
                      iconBg: isDark
                          ? const Color(0xFF1A1B2E)
                          : const Color(0xFFE8EAF6),
                      iconColor: const Color(0xFF818CF8),
                      title: 'Gelap',
                      subtitle:
                          'Mengurangi kelelahan mata di malam hari',
                      mode: ThemeMode.dark,
                      current: current,
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Custom theme option card — no FTile
// ---------------------------------------------------------------------------
class _ThemeOptionCard extends StatefulWidget {
  final BuildContext ctx;
  final ThemeController themeC;
  final bool isDark;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final ThemeMode mode;
  final ThemeMode current;

  const _ThemeOptionCard({
    required this.ctx,
    required this.themeC,
    required this.isDark,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.mode,
    required this.current,
  });

  @override
  State<_ThemeOptionCard> createState() => _ThemeOptionCardState();
}

class _ThemeOptionCardState extends State<_ThemeOptionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isSelected = widget.current == widget.mode;
    final green = const Color(0xFF4CAF50);
    final cardBg = isDark ? const Color(0xFF1E2229) : Colors.white;
    final pressedBg =
        isDark ? const Color(0xFF242B35) : const Color(0xFFF5F5F5);
    final border = isSelected
        ? green.withAlpha(isDark ? 120 : 80)
        : (isDark ? const Color(0xFF2C3040) : const Color(0xFFEEEEEE));
    final titleColor =
        isSelected ? green : (isDark ? const Color(0xFFDDE2EA) : const Color(0xFF1A1A1A));
    final subColor = isDark ? const Color(0xFF6B7280) : const Color(0xFF9E9E9E);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.themeC.setTheme(widget.mode);
        Navigator.of(widget.ctx).pop();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? green.withAlpha(15)
                  : green.withAlpha(8))
              : (_pressed ? pressedBg : cardBg),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: widget.iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      )),
                  const SizedBox(height: 2),
                  Text(widget.subtitle,
                      style: TextStyle(fontSize: 12, color: subColor)),
                ],
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 10),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
