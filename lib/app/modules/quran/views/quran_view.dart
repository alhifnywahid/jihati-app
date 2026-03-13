import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/modules/quran/controllers/quran_controller.dart';
import 'package:jihati/app/routes/app_pages.dart';
import 'package:jihati/app/widgets/custom_search_bar.widget.dart';
import 'package:jihati/app/widgets/frame_ayat.widget.dart';
import 'package:jihati/app/widgets/green_header.widget.dart';
import 'package:jihati/app/widgets/no_result.widget.dart';
import 'package:jihati/app/widgets/theme_sheet.widget.dart';

class QuranView extends GetView<QuranController> {
  const QuranView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuranController>();
    final searchController = TextEditingController();
    final searchFocusNode = FocusNode();
    final themeC = Get.find<ThemeController>();
    searchController.text = '';

    return Scaffold(
      appBar: greenAppBar(
        context: context,
        title: "Al-Qur'an",
        actions: [
          Obx(() => FHeaderAction(
            icon: Icon(themeC.currentThemeIcon, color: Colors.white, size: 20),
            onPress: () => ThemeSheetDialog.show(context),
          )),
          FHeaderAction(
            icon: const Icon(FIcons.history, color: Colors.white, size: 20),
            onPress: () => Get.toNamed(Routes.history),
          ),
          FHeaderAction(
            icon: const Icon(FIcons.bookmark, color: Colors.white, size: 20),
            onPress: () => Get.toNamed(Routes.bookmark),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return GestureDetector(
          onTap: () => searchFocusNode.unfocus(),
          child: Column(
            children: [
              CustomSearchBarWidget(
                text: 'Cari Nama Surah',
                searchController: searchController,
                focusNode: searchFocusNode,
                onChange: (query) => controller.filterSurah(query),
              ),
              Expanded(
                child: controller.filteredSurah.isEmpty &&
                        controller.searchQuery.isNotEmpty
                    ? const NoResultWidget(text: 'Tidak ada hasil pencarian!')
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: controller.filteredSurah.length,
                        itemBuilder: (context, index) {
                          final surah = controller.filteredSurah[index];
                          return _SurahCard(
                            surah: surah,
                            isDark: isDark,
                            onTap: () {
                              searchFocusNode.unfocus();
                              Get.toNamed(
                                Routes.quranDetail,
                                arguments: {
                                  'surah': surah,
                                  'listSurah': controller.filteredSurah,
                                  'currentIndex': index,
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Premium Surah card — matches Jihati list card style
// ---------------------------------------------------------------------------
class _SurahCard extends StatefulWidget {
  final dynamic surah;
  final bool isDark;
  final VoidCallback onTap;

  const _SurahCard({
    required this.surah,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_SurahCard> createState() => _SurahCardState();
}

class _SurahCardState extends State<_SurahCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final cardBg = isDark ? const Color(0xFF1E2229) : Colors.white;
    final cardBgPressed =
        isDark ? const Color(0xFF242B35) : const Color(0xFFF0F7F0);
    final borderColor =
        isDark ? const Color(0xFF2C3040) : const Color(0xFFEEEEEE);
    final titleColor =
        isDark ? const Color(0xFFDDE2EA) : const Color(0xFF1A1A1A);
    final subtitleColor =
        isDark ? const Color(0xFF8B9099) : const Color(0xFF757575);
    final surahIconColor =
        isDark ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32);

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
          color: _pressed ? cardBgPressed : cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Surah number frame
              FrameAyat(text: widget.surah.id.toString()),
              const SizedBox(width: 14),
              // Latin name + translation · verse count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.surah.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.surah.translate} · ${widget.surah.verseCount} ayat',
                      style: TextStyle(fontSize: 12, color: subtitleColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Arabic surah name (icon font)
              Text(
                String.fromCharCode(0xE800 + (widget.surah.id as int)),
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'SurahQuranNU',
                  color: surahIconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
