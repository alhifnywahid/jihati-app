import 'package:flutter/material.dart';
import 'package:jihati/app/widgets/frame_ayat.widget.dart';

class JihatiListViewWidget extends StatelessWidget {
  final List<dynamic> items;
  final void Function(dynamic item)? onItemTap;

  const JihatiListViewWidget({super.key, required this.items, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text("Tidak ada data"));
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            if (onItemTap != null) onItemTap!(item);
            // Navigasi sekarang dilakukan dari onItemTap di JihatiView
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                FrameAyat(text: (index + 1).toString()),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.titleArabic,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'OmarNaskh',
                      fontSize: 23,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // _openDetail dihapus, navigasi dilakukan dari onItemTap
}
