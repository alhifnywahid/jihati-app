import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurvedNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<CurvedNavItem> items;

  const CurvedNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium colors
    final activeGreen = const Color(0xFF2E7D32);

    final inactiveColor = isDark
        ? const Color(0xFF4A5568)
        : const Color(0xFFB0BEC5);
    final borderColor = isDark
        ? const Color(0xFF1E2229)
        : const Color(0xFFE8E8E8);

    // Navbar background: dark = deep matte, light = pure white
    final bgColors = isDark
        ? [const Color(0xFF12151C), const Color(0xFF181C24)]
        : [Colors.white, const Color(0xFFFAFAFA)];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: bgColors,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 66,
            child: Row(
              children: List.generate(items.length, (i) {
                final isSelected = i == selectedIndex;
                final item = items[i];

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onTap(i);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Active indicator circle
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            width: 34,
                            height: 34,
                            decoration: isSelected
                                ? BoxDecoration(
                                    color: activeGreen.withAlpha(22),
                                    shape: BoxShape.circle,
                                  )
                                : null,
                            child: Center(
                              child: Icon(
                                item.icon,
                                size: 17,
                                color: isSelected
                                    ? activeGreen
                                    : inactiveColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? activeGreen : inactiveColor,
                            ),
                            child: Text(item.label),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class CurvedNavItem {
  final IconData icon;
  final String label;

  const CurvedNavItem({required this.icon, required this.label});
}
