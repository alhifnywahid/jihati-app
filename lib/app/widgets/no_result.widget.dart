import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoResultWidget extends StatelessWidget {
  final String text;
  const NoResultWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            'assets/lottie/lottie-empty-result.json',
            width: 250,
            height: 250,
            reverse: true,
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
