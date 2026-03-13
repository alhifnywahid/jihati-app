import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CustomSearchBarWidget extends StatefulWidget {
  final String text;
  final TextEditingController searchController;
  final FocusNode focusNode;
  final ValueChanged<String> onChange;

  const CustomSearchBarWidget({
    super.key,
    required this.text,
    required this.searchController,
    required this.focusNode,
    required this.onChange,
  });

  @override
  State<CustomSearchBarWidget> createState() => _CustomSearchBarWidgetState();
}

class _CustomSearchBarWidgetState extends State<CustomSearchBarWidget> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colors
    final fillColor = isDark
        ? const Color(0xFF1E2229)
        : const Color(0xFFF5F5F5);
    final borderColor = _focused
        ? const Color(0xFF2E7D32)
        : (isDark ? const Color(0xFF2C3040) : const Color(0xFFE0E0E0));
    final hintColor = isDark
        ? const Color(0xFF545B68)
        : const Color(0xFFAAAAAA);
    final iconColor = _focused
        ? const Color(0xFF2E7D32)
        : (isDark ? const Color(0xFF545B68) : const Color(0xFFAAAAAA));
    final textColor = isDark
        ? const Color(0xFFDDE2EA)
        : const Color(0xFF1A1A1A);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: _focused ? 1.5 : 1.0,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withAlpha(30),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                ],
        ),
        child: TextField(
          controller: widget.searchController,
          focusNode: widget.focusNode,
          onChanged: widget.onChange,
          style: TextStyle(color: textColor, fontSize: 14),
          cursorColor: const Color(0xFF2E7D32),
          decoration: InputDecoration(
            hintText: widget.text,
            hintStyle: TextStyle(color: hintColor, fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Icon(LucideIcons.search, size: 18, color: iconColor),
            ),
            prefixIconConstraints: const BoxConstraints(),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget.searchController,
              builder: (_, value, _) => value.text.isEmpty
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        widget.searchController.clear();
                        widget.onChange('');
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          LucideIcons.x,
                          size: 16,
                          color: hintColor,
                        ),
                      ),
                    ),
            ),
            suffixIconConstraints: const BoxConstraints(),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 13,
            ),
          ),
        ),
      ),
    );
  }
}
