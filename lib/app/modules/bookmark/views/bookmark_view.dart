import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:jihati/app/modules/jihati/controllers/jihati_controller.dart';
import 'package:jihati/app/modules/quran/controllers/quran_controller.dart';
import 'package:jihati/app/routes/app_pages.dart';
import 'package:jihati/app/services/quran_storage_service.dart';
import 'package:jihati/app/widgets/frame_ayat.widget.dart';
import 'package:jihati/app/widgets/jihati_list_view.widget.dart';
import 'package:jihati/app/widgets/no_result.widget.dart';

class BookmarkView extends GetView<BookmarkController> {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Tersimpan'),
        prefixes: [FHeaderAction.back(onPress: () => Get.back())],
        suffixes: [
          Obx(() {
            final hasJihatiBookmarks = controller.bookmarks.isNotEmpty;
            final hasQuranBookmarks =
                QuranStorageService().getBookmarks().isNotEmpty;
            if (!hasJihatiBookmarks && !hasQuranBookmarks) {
              return const SizedBox.shrink();
            }
            return FHeaderAction(
              icon: const Icon(FIcons.trash2),
              onPress: () => _showClearDialog(context),
            );
          }),
        ],
      ),
      child: FTabs(
        children: [
          FTabEntry(
            label: const Text('Jihati'),
            child: const _JihatiBookmarkContent(),
          ),
          FTabEntry(
            label: const Text('Al-Quran'),
            child: const _AlquranBookmarkContent(),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showFDialog(
      context: context,
      builder: (context, _, __) => FDialog(
        title: const Text('Hapus Tersimpan'),
        body: const Text('Apakah Anda yakin ingin menghapus semua data tersimpan?'),
        actions: [
          FButton(
            onPress: () => Get.back(),
            child: const Text('Batal'),
          ),
          FButton(
            onPress: () {
              final bookmarkController = Get.find<BookmarkController>();
              bookmarkController.bookmarks.clear();
              bookmarkController.storage.saveBookmarks([]);
              QuranStorageService().saveBookmarks([]);
              Get.back();
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _JihatiBookmarkContent extends StatelessWidget {
  const _JihatiBookmarkContent();

  @override
  Widget build(BuildContext context) {
    final bookmarkController = Get.find<BookmarkController>();
    final jihatiController = Get.find<JihatiController>();

    return Obx(() {
      final bookmarkIds = bookmarkController.bookmarks;
      final bookmarkedItems = jihatiController.contents
          .where((item) => bookmarkIds.contains(item.id.toString()))
          .toList();

      if (bookmarkedItems.isEmpty) {
        return const NoResultWidget(text: 'Belum ada jihati yang tersimpan!');
      }

      return JihatiListViewWidget(
        items: bookmarkedItems,
        onItemTap: (item) {
          final index = bookmarkedItems.indexOf(item);
          Get.toNamed(
            Routes.jihatiDetail,
            arguments: {
              'id': item.id,
              'arabicTitle': item.titleArabic,
              'latinTitle': item.titleLatin,
              'listItems': bookmarkedItems,
              'currentIndex': index,
            },
          );
        },
      );
    });
  }
}

class _AlquranBookmarkContent extends StatefulWidget {
  const _AlquranBookmarkContent();

  @override
  State<_AlquranBookmarkContent> createState() =>
      _AlquranBookmarkContentState();
}

class _AlquranBookmarkContentState extends State<_AlquranBookmarkContent> {
  @override
  Widget build(BuildContext context) {
    final quranController = Get.find<QuranController>();
    final bookmarkIds = QuranStorageService().getBookmarks();
    final bookmarkedSurah = quranController.allSurah
        .where((s) => bookmarkIds.contains(s.id.toString()))
        .toList();

    if (bookmarkedSurah.isEmpty) {
      return const NoResultWidget(text: "Belum ada al-qur'an yang tersimpan!");
    }

    return ListView.builder(
      itemCount: bookmarkedSurah.length,
      itemBuilder: (context, index) {
        final surah = bookmarkedSurah[index];
        return FTile(
          prefix: FrameAyat(text: surah.id.toString()),
          title: Text(surah.name, style: const TextStyle(fontSize: 16)),
          subtitle: Text('${surah.translate} (${surah.verseCount} ayat)'),
          suffix: Text(
            String.fromCharCode(0xE800 + (surah.id)),
            style: const TextStyle(fontSize: 26, fontFamily: 'SurahQuranNU'),
          ),
          onPress: () {
            Get.toNamed(
              Routes.quranDetail,
              arguments: {
                'surah': surah,
                'listSurah': bookmarkedSurah,
                'currentIndex': index,
              },
            );
          },
        );
      },
    );
  }
}
