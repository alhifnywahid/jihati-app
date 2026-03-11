import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class NoResultWidget extends StatelessWidget {
  final String text;

  const NoResultWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: FAlert(
        icon: const Icon(FIcons.searchX),
        title: const Text('Tidak Ditemukan'),
        subtitle: Text(text),
      ),
    );
  }
}
