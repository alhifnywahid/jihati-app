import 'package:flutter/material.dart';

class CustomSearchBarWidget extends StatelessWidget {
  final String text;
  final TextEditingController searchController;
  final void Function(String) onChange;
  final FocusNode? focusNode;

  const CustomSearchBarWidget({
    super.key,
    required this.text,
    required this.searchController,
    required this.onChange,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: searchController,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: const TextStyle(
            // color: Color(0xFFBDBDBD),
            fontSize: 14,
          ),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFBDBDBD)),
          fillColor: const Color(0xFFF4F4F6),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            borderSide: const BorderSide(color: Colors.grey, width: .5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            gapPadding: 0,
            borderSide: const BorderSide(color: Colors.grey, width: .5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: .5),
          ),
        ),
        onChanged: onChange,
      ),
    );
  }
}
