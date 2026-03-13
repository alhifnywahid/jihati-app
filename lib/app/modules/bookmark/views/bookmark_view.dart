import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jihati/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:jihati/app/modules/jihati/controllers/jihati_controller.dart';
import 'package:jihati/app/modules/quran/controllers/quran_controller.dart';
import 'package:jihati/app/routes/app_pages.dart';
import 'package:jihati/app/services/quran_storage_service.dart';
import 'package:jihati/app/widgets/confirm_delete_sheet.widget.dart';
import 'package:jihati/app/widgets/frame_ayat.widget.dart';
import 'package:jihati/app/widgets/green_header.widget.dart';
import 'package:jihati/app/widgets/jihati_list_view.widget.dart';
import 'package:jihati/app/widgets/no_result.widget.dart';

class BookmarkView extends GetView<BookmarkController> {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(top: false,
          child: Column(
            children: [
              // Header with delete action
              GreenHeader(
                title: 'Tersimpan',
                suffixes: [
                  Obx(() {
                    final hasJihati = controller.bookmarks.isNotEmpty;
                    final hasQuran =
                        QuranStorageService().getBookmarks().isNotEmpty;
                    if (!hasJihati && !hasQuran) return const SizedBox.shrink();
                    return Builder(
                      builder: (ctx) => GreenHeaderAction(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.white, size: 20),
                        onPress: () => _showClearDialog(ctx),
                      ),
                    );
                  }),
                ],
              ),
              // Premium tab bar
              _PremiumTabBar(tabs: const ['Jihati', 'Al-Quran']),
              // Tab content
              const Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    _JihatiBookmarkContent(),
                    _AlquranBookmarkContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context) async {
    final tabIndex = DefaultTabController.of(context).index;
    final isJihati = tabIndex == 0;

    final confirmed = await ConfirmDeleteSheet.show(
      context: context,
      title: 'Hapus Tersimpan',
      message: isJihati
          ? 'Hapus semua Jihati yang tersimpan?'
          : 'Hapus semua Al-Quran yang tersimpan?',
    );
    if (confirmed) {
      if (isJihati) {
        controller.bookmarks.clear();
        controller.storage.saveBookmarks([]);
      } else {
        QuranStorageService().saveBookmarks([]);
        controller.incrementQuranVersion();
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Premium custom TabBar
// ---------------------------------------------------------------------------
class _PremiumTabBar extends StatelessWidget {
  final List<String> tabs;
  const _PremiumTabBar({required this.tabs});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E2229) : const Color(0xFFF5F5F5);
    final activeBg = isDark ? const Color(0xFF1A3A1F) : const Color(0xFF2E7D32);
    final inactiveText = isDark ? const Color(0xFF6B7280) : const Color(0xFF9E9E9E);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          indicator: BoxDecoration(
            color: activeBg,
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: inactiveText,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.all(4),
          tabs: tabs.map((t) => Tab(text: t, height: 34)).toList(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Jihati bookmark content
// ---------------------------------------------------------------------------
class _JihatiBookmarkContent extends StatelessWidget {
  const _JihatiBookmarkContent();

  @override
  Widget build(BuildContext context) {
    final bookmarkC = Get.find<BookmarkController>();
    final jihatiC = Get.find<JihatiController>();

    return Obx(() {
      final ids = bookmarkC.bookmarks;
      final items = jihatiC.contents
          .where((item) => ids.contains(item.id.toString()))
          .toList();
      if (items.isEmpty) {
        return const NoResultWidget(text: 'Belum ada jihati yang tersimpan!');
      }
      return JihatiListViewWidget(
        items: items,
        onItemTap: (item) {
          final idx = items.indexOf(item);
          Get.toNamed(Routes.jihatiDetail, arguments: {
            'id': item.id,
            'arabicTitle': item.titleArabic,
            'latinTitle': item.titleLatin,
            'listItems': items,
            'currentIndex': idx,
          });
        },
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Quran bookmark content — premium card items
// ---------------------------------------------------------------------------
class _AlquranBookmarkContent extends StatefulWidget {
  const _AlquranBookmarkContent();

  @override
  State<_AlquranBookmarkContent> createState() =>
      _AlquranBookmarkContentState();
}

class _AlquranBookmarkContentState extends State<_AlquranBookmarkContent> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookmarkC = Get.find<BookmarkController>();

    return Obx(() {
      // Observe quranBookmarkVersion so this rebuilds when Quran bookmarks change
      bookmarkC.quranBookmarkVersion.value;

      final quranC = Get.find<QuranController>();
      final ids = QuranStorageService().getBookmarks();
      final surahs = quranC.allSurah
          .where((s) => ids.contains(s.id.toString()))
          .toList();

      if (surahs.isEmpty) {
        return const NoResultWidget(
            text: "Belum ada Al-Qur'an yang tersimpan!");
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        itemCount: surahs.length,
        itemBuilder: (context, i) => _SurahCard(
          surah: surahs[i],
          isDark: isDark,
          onTap: () => Get.toNamed(Routes.quranDetail, arguments: {
            'surah': surahs[i],
            'listSurah': surahs,
            'currentIndex': i,
          }),
        ),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Premium surah card (same style as QuranView)
// ---------------------------------------------------------------------------
class _SurahCard extends StatefulWidget {
  final dynamic surah;
  final bool isDark;
  final VoidCallback onTap;
  const _SurahCard(
      {required this.surah, required this.isDark, required this.onTap});

  @override
  State<_SurahCard> createState() => _SurahCardState();
}

class _SurahCardState extends State<_SurahCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final cardBg = isDark ? const Color(0xFF1E2229) : Colors.white;
    final cardPressed =
        isDark ? const Color(0xFF242B35) : const Color(0xFFF0F7F0);
    final border = isDark ? const Color(0xFF2C3040) : const Color(0xFFEEEEEE);
    final title = isDark ? const Color(0xFFDDE2EA) : const Color(0xFF1A1A1A);
    final sub = isDark ? const Color(0xFF8B9099) : const Color(0xFF757575);
    final icon = isDark ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: _pressed ? cardPressed : cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              FrameAyat(text: widget.surah.id.toString()),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.surah.name,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: title)),
                    const SizedBox(height: 2),
                    Text(
                        '${widget.surah.translate} · ${widget.surah.verseCount} ayat',
                        style: TextStyle(fontSize: 12, color: sub)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                String.fromCharCode(0xE800 + (widget.surah.id as int)),
                style: TextStyle(
                    fontSize: 30, fontFamily: 'SurahQuranNU', color: icon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

