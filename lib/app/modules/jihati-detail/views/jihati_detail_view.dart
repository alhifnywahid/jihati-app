import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:jihati/app/modules/history/controllers/history_controller.dart';
import 'package:jihati/app/widgets/green_header.widget.dart';
import 'package:jihati/app/widgets/jihati_type.widget.dart';
import 'package:jihati/app/widgets/reading_preference_dialog.widget.dart';
import 'package:jihati/app/widgets/theme_sheet.widget.dart';

class JihatiDetailView extends StatefulWidget {
  const JihatiDetailView({super.key});

  @override
  State<JihatiDetailView> createState() => _JihatiDetailViewState();
}

class _JihatiDetailViewState extends State<JihatiDetailView> {
  late List listItems;
  late int currentIndex;
  late PageController _pageController;
  Map<String, dynamic>? detailData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    listItems = args['listItems'] ?? [];
    currentIndex = args['currentIndex'] ?? 0;
    _pageController = PageController(initialPage: currentIndex);
    _loadDetail(listItems[currentIndex].id);
  }

  Future<void> _loadDetail(int id) async {
    setState(() => isLoading = true);
    final assetPath = 'assets/data/jihati/$id.json';
    try {
      final String detailJson = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> data = json.decode(detailJson);
      setState(() {
        detailData = data;
        isLoading = false;
      });
      final item = listItems[currentIndex];
      final historyController = Get.find<HistoryController>();
      historyController.addToHistory(item);
    } catch (e) {
      setState(() {
        detailData = null;
        isLoading = false;
      });
    }
  }

  void _onPageChanged(int index) {
    if (index < 0 || index >= listItems.length) return;
    setState(() => currentIndex = index);
    _loadDetail(listItems[index].id);
  }

  @override
  Widget build(BuildContext context) {
    final BookmarkController bookmarkController = Get.find();
    final themeC = Get.find<ThemeController>();
    final item = listItems[currentIndex];
    final int id = item.id;
    final String latinTitle = item.titleLatin;

    return Scaffold(
      body: SafeArea(top: false,
        child: Column(
          children: [
            GreenHeader(
              title: latinTitle,
              suffixes: [
                Obx(() => GreenHeaderAction(
                  icon: Icon(themeC.currentThemeIcon, color: Colors.white, size: 20),
                  onPress: () => ThemeSheetDialog.show(context),
                )),
                GreenHeaderAction(
                  icon: const Icon(Icons.format_size, color: Colors.white, size: 20),
                  onPress: () => ReadingPreferenceDialog.show(context),
                ),
                Obx(() => GreenHeaderAction(
                  icon: Icon(
                    bookmarkController.isBookmarked(id)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPress: () =>
                      bookmarkController.toggleBookmark(id, latinTitle),
                )),
              ],
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: listItems.length,
                onPageChanged: (index) {
                  if (index < 0 || index >= listItems.length) return;
                  _onPageChanged(index);
                },
                itemBuilder: (context, index) {
                  final pageItem = listItems[index];
                  final String pageArabicTitle = pageItem.titleArabic;
                  final bool pageNotAvailable = detailData == null;
                  final int? pageSchemaType =
                      detailData?['schema']?['type'] as int?;
                  final dynamic pageDetail = detailData?['content'];

                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: [
                      // ── Title info bar — same style as Quran detail ──
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.5,
                              color: Colors.grey.withAlpha(120),
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '\uFD3E $pageArabicTitle \uFD3F',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'OmarNaskh',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      // ── Content ──
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (pageNotAvailable) ...[
                                const SizedBox(height: 24),
                                Text(
                                  pageArabicTitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'LPMQ-IsepMisbah',
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Data belum tersedia',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.red),
                                ),
                              ] else ...[
                                JihatiTypeWidget(
                                  schemaType: pageSchemaType ?? 0,
                                  content: (pageSchemaType == 2 &&
                                          pageDetail is List)
                                      ? List<String>.from(pageDetail)
                                      : pageDetail,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
