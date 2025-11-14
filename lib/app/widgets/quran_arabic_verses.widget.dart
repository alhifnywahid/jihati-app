import 'package:flutter/material.dart';
import 'package:jihati/utils/number_utils.dart';

class QuranArabicVersesWidget extends StatelessWidget {
  final List<String> verses;
  final double fontSize;

  const QuranArabicVersesWidget({
    super.key,
    required this.verses,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'OmarNaskh',
          fontSize: fontSize,
          height: 1.5,
        ),
        children: verses.asMap().entries.map((entry) {
          final int verseNumber = entry.key + 1;
          final String verse = entry.value;
          return TextSpan(
            children: [
              TextSpan(
                text: '$verse ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              TextSpan(
                text: '\u06DD${toArabicNumber(verseNumber)} ',
                style: TextStyle(
                  fontSize: fontSize * 0.8,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
