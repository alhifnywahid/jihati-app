import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FrameAyat extends StatelessWidget {
  final String text;

  const FrameAyat({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/svg/frameAyat.svg',
          width: 35,
          height: 35,
          semanticsLabel: text,
        ),
        Text(text, style: const TextStyle(fontSize: 11, fontFamily: 'Inter')),
      ],
    );
  }
}
