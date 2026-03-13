import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/reading_preference_controller.dart';

/// Premium reading preference bottom sheet.
class ReadingPreferenceDialog {
  ReadingPreferenceDialog._();

  static Future<void> show(BuildContext context) async {
    if (!Get.isRegistered<ReadingPreferenceController>()) {
      Get.put(ReadingPreferenceController());
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return _ReadingPrefSheet(isDark: isDark);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet UI
// ---------------------------------------------------------------------------
class _ReadingPrefSheet extends StatelessWidget {
  final bool isDark;
  const _ReadingPrefSheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final pref = Get.find<ReadingPreferenceController>();
    final sheetBg = isDark ? const Color(0xFF13151A) : Colors.white;
    final handleColor =
        isDark ? Colors.white.withAlpha(30) : Colors.grey.withAlpha(80);
    final cardBg =
        isDark ? const Color(0xFF1E2229) : const Color(0xFFF7F7F7);
    final cardBorder =
        isDark ? const Color(0xFF2C3040) : const Color(0xFFE8E8E8);
    final sectionTitle =
        isDark ? const Color(0xFFDDE2EA) : const Color(0xFF1A1A1A);
    final green = const Color(0xFF4CAF50);

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: isDark
            ? Border(
                top: BorderSide(color: Colors.white.withAlpha(12), width: 1))
            : null,
      ),
      padding: EdgeInsets.fromLTRB(
        20, 12, 20,
        MediaQuery.of(context).viewInsets.bottom + 36,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle bar ──────────────────────────────────────────────
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 28),
            decoration: BoxDecoration(
              color: handleColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Icon + Title ────────────────────────────────────────────
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color:
                  isDark ? const Color(0xFF1A3A1F) : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(LucideIcons.type, color: green, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            'Preferensi Membaca',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFDDE2EA) : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sesuaikan tampilan teks Arab sesuai kenyamanan Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? const Color(0xFF6B7280)
                  : const Color(0xFF9E9E9E),
            ),
          ),
          const SizedBox(height: 28),

          // ── Font size control card ──────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cardBorder),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label row
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1A3A1F)
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(LucideIcons.a_large_small,
                          color: green, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Ukuran Teks Arab',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: sectionTitle,
                      ),
                    ),
                    const Spacer(),
                    // Size badge
                    Obx(() => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: green.withAlpha(isDark ? 30 : 20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${pref.arabicFontSize.value.toInt()} px',
                            style: TextStyle(
                              color: green,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 20),

                // Stepper row – preview –
                Row(
                  children: [
                    _StepButton(
                      icon: LucideIcons.minus,
                      onTap: pref.decreaseArabicFontSize,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() => Text(
                            'بِسْمِ اللّٰهِ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'LPMQ-IsepMisbah',
                              fontSize: pref.arabicFontSize.value,
                              color: isDark
                                  ? const Color(0xFFDDE2EA)
                                  : const Color(0xFF1A1A1A),
                            ),
                          )),
                    ),
                    const SizedBox(width: 16),
                    _StepButton(
                      icon: LucideIcons.plus,
                      onTap: pref.increaseArabicFontSize,
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stepper button
// ---------------------------------------------------------------------------
class _StepButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  const _StepButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_StepButton> createState() => _StepButtonState();
}

class _StepButtonState extends State<_StepButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = _pressed
        ? (isDark ? const Color(0xFF2A3240) : const Color(0xFFE8F5E9))
        : (isDark ? const Color(0xFF1E2229) : Colors.white);
    final border =
        isDark ? const Color(0xFF2C3040) : const Color(0xFFDDDDDD);
    final iconColor = isDark ? const Color(0xFFDDE2EA) : const Color(0xFF333333);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Icon(widget.icon, size: 18, color: iconColor),
      ),
    );
  }
}
