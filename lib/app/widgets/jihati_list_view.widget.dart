import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: FTile(
            prefix: FrameAyat(text: (index + 1).toString()),
            title: Text(
              item.titleArabic,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontFamily: 'OmarNaskh',
                fontSize: 22,
                height: 1.5,
              ),
            ),
            subtitle: Text(
              item.titleLatin,
              style: const TextStyle(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            suffix: const Icon(FIcons.chevronRight),
            onPress: () {
              if (onItemTap != null) onItemTap!(item);
            },
          ),
        );
      },
    );
  }
}
