import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/utils/number_utils.dart';

import '../controllers/reading_preference_controller.dart';
import 'quran_arabic_verses.widget.dart';

class JihatiTypeWidget extends StatelessWidget {
  final int schemaType;
  final dynamic content;

  const JihatiTypeWidget({
    super.key,
    required this.schemaType,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final ReadingPreferenceController controller = Get.find();

    return Obx(() {
      final double arabicFontSize = controller.arabicFontSize.value;

      Widget child;

      if (schemaType == 1) {
        child = Text(
          content as String,
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: 'OmarNaskh',
            fontWeight: FontWeight.w500,
            fontSize: arabicFontSize,
            height: 2,
          ),
        );
      } else if (schemaType == 2 || schemaType == 4) {
        final List<String> lines = content is List
            ? List<String>.from(content)
            : (content as String).split('\n');

        child = Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(lines.length * 2 - 1, (index) {
            if (index.isEven) {
              final line = lines[index ~/ 2];
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  line,
                  textAlign: schemaType == 2
                      ? TextAlign.justify
                      : TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'OmarNaskh',
                    fontWeight: FontWeight.w500,
                    fontSize: arabicFontSize,
                  ),
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1),
              );
            }
          }),
        );
      } else if (schemaType == 3) {
        if (content is! List) {
          child = const Text('Tipe konten untuk skema 3 tidak valid.');
        } else {
          final items = content as List;
          child = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items.expand<Widget>((item) {
              if (item is List && item.length >= 2) {
                return [
                  Text(
                    item[0].toString(),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'OmarNaskh',
                      fontWeight: FontWeight.w500,
                      fontSize: arabicFontSize,
                      height: 2,
                    ),
                  ),
                  Text(
                    item[1].toString(),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'OmarNaskh',
                      fontWeight: FontWeight.w500,
                      fontSize: arabicFontSize,
                      height: 2,
                    ),
                  ),
                ];
              } else {
                return [
                  Text(
                    item.toString(),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'OmarNaskh',
                      fontWeight: FontWeight.w500,
                      fontSize: arabicFontSize,
                      height: 2,
                    ),
                  ),
                ];
              }
            }).toList(),
          );
        }
      } else if (schemaType == 5) {
        if (content is! List) {
          child = const Text('Tipe konten untuk skema 5 tidak valid.');
        } else {
          final List<String> verses = List<String>.from(content);
          child = QuranArabicVersesWidget(verses: verses, fontSize: arabicFontSize);
        }
      } else if (schemaType == 6) {
        child = JihatiType6Widget(
          content: content,
          arabicFontSize: arabicFontSize,
        );
      } else {
        child = const Text('Tipe konten belum didukung');
      }

      return FCard(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: child,
        ),
      );
    });
  }
}

class JihatiType6Widget extends StatelessWidget {
  final Map<String, dynamic> content;
  final double arabicFontSize;

  const JihatiType6Widget({
    super.key,
    required this.content,
    required this.arabicFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final pembuka = content['pembuka'];
    final List sholatList = content['sholat'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildLine(context, 'بِلَال :', pembuka['bilal']),
        const SizedBox(height: 10),
        _buildLine(context, 'جَمَاعَة :', pembuka['jamaah']),
        const Divider(thickness: 1, height: 32),
        ...List.generate(sholatList.length, (index) {
          final item = sholatList[index];
          final rakaat = item['rakaat'] as List;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildLine(
                context,
                'رَكْعَة ${toArabicNumber((index * 2) + 1)}:',
                'سورة ${rakaat[0]}',
              ),
              _buildLine(
                context,
                'رَكْعَة ${toArabicNumber((index * 2) + 2)}:',
                'سورة ${rakaat[1]}',
              ),
              const SizedBox(height: 12),
              _buildLine(context, 'بِلَال :', item['bilal']),
              const SizedBox(height: 8),
              _buildLine(context, 'جَمَاعَة :', item['jamaah']),
              const Divider(thickness: 1, height: 32),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildLine(BuildContext context, String label, String value) {
    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        text: '$label ',
        style: DefaultTextStyle.of(context).style.copyWith(
          fontFamily: 'OmarNaskh',
          fontSize: arabicFontSize,
          fontWeight: FontWeight.w600,
          height: 2,
        ),
        children: [
          TextSpan(
            text: value,
            style: DefaultTextStyle.of(context).style.copyWith(
              fontFamily: 'OmarNaskh',
              fontSize: arabicFontSize,
              fontWeight: FontWeight.normal,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
