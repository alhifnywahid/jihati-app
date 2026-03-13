import 'package:flutter/material.dart';
import 'package:jihati/app/widgets/frame_ayat.widget.dart';

class JihatiListViewWidget extends StatelessWidget {
  final List<dynamic> items;
  final void Function(dynamic item)? onItemTap;

  const JihatiListViewWidget({super.key, required this.items, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _JihatiListItem(
          index: index,
          item: item,
          isDark: isDark,
          onTap: () => onItemTap?.call(item),
        );
      },
    );
  }
}

class _JihatiListItem extends StatefulWidget {
  final int index;
  final dynamic item;
  final bool isDark;
  final VoidCallback onTap;

  const _JihatiListItem({
    required this.index,
    required this.item,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_JihatiListItem> createState() => _JihatiListItemState();
}

class _JihatiListItemState extends State<_JihatiListItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    // Card background colours
    final cardBg = isDark
        ? const Color(0xFF1E2229) // slightly lighter than scaffold
        : Colors.white;
    final cardBgPressed = isDark
        ? const Color(0xFF242B35)
        : const Color(0xFFF0F7F0);
    final borderColor = isDark
        ? const Color(0xFF2C3040)
        : const Color(0xFFEEEEEE);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: _pressed ? cardBgPressed : cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Frame number
              FrameAyat(text: (widget.index + 1).toString()),
              const SizedBox(width: 16),
              // Arabic title
              Expanded(
                child: Text(
                  widget.item.titleArabic,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'OmarNaskh',
                    fontSize: 23,
                    height: 1.6,
                    color: isDark
                        ? const Color(0xFFDDE2EA) // slightly off-white
                        : const Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
