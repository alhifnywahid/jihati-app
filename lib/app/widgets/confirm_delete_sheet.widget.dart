import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class ConfirmDeleteSheet {
  ConfirmDeleteSheet._();

  /// Shows a premium bottom sheet confirmation for delete actions.
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Hapus',
    String cancelLabel = 'Batal',
  }) async {

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final sheetBg = isDark ? const Color(0xFF13151A) : Colors.white;
        final handleColor =
            isDark ? Colors.white.withAlpha(30) : Colors.grey.withAlpha(80);
        final titleColor =
            isDark ? const Color(0xFFDDE2EA) : const Color(0xFF1A1A1A);
        final subColor =
            isDark ? const Color(0xFF6B7280) : const Color(0xFF757575);
        final cancelBg =
            isDark ? const Color(0xFF1E2229) : const Color(0xFFF0F0F0);
        final cancelText =
            isDark ? const Color(0xFF8B9099) : const Color(0xFF555555);

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
            24, 12, 24,
            MediaQuery.of(context).viewInsets.bottom + 36,
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

              // Warning icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(isDark ? 30 : 20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.trash_2,
                  color: Colors.redAccent,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 8),

              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: subColor,
                ),
              ),
              const SizedBox(height: 28),

              // Buttons row
              Row(
                children: [
                  // Cancel
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx, false),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: cancelBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          cancelLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: cancelText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Confirm (red)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx, true),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE53935), Color(0xFFC62828)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withAlpha(isDark ? 40 : 60),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          confirmLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }
}
