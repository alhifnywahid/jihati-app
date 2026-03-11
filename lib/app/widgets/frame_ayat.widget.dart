import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class FrameAyat extends StatelessWidget {
  final String text;

  const FrameAyat({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return FBadge(
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontFamily: 'Inter'),
      ),
    );
  }
}
