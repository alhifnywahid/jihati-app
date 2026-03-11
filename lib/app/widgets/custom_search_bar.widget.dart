import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class CustomSearchBarWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Use Material color scheme since FTheme bridges to material.
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: TextField(
        controller: searchController,
        focusNode: focusNode,
        onChanged: onChange,
        decoration: InputDecoration(
          hintText: text,
          prefixIcon: const Icon(FIcons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: cs.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: cs.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: cs.primary, width: 1.5),
          ),
          filled: true,
          fillColor: cs.surfaceContainerHighest.withAlpha(80),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}
