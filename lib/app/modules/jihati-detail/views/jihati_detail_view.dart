import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/get.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:jihati/app/modules/history/controllers/history_controller.dart';
import 'package:jihati/app/widgets/jihati_type.widget.dart';
import 'package:jihati/app/widgets/reading_preference_dialog.widget.dart';

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
    setState(() {
      isLoading = true;
    });
    final assetPath = 'assets/data/jihati/$id.json';
    try {
      final String detailJson = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> data = json.decode(detailJson);
      setState(() {
        detailData = data;
        isLoading = false;
      });
      // Tambahkan ke history setiap kali detail berhasil dimuat
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
    setState(() {
      currentIndex = index;
    });
    _loadDetail(listItems[index].id);
  }

  @override
  Widget build(BuildContext context) {
    final BookmarkController bookmarkController = Get.find();
    final ThemeController themeC = Get.find();
    final item = listItems[currentIndex];
    final id = item.id;
    final arabicTitle = item.titleArabic;
    final latinTitle = item.titleLatin;
    final notAvailable = detailData == null;
    final schemaType = detailData?['schema']?['type'] as int?;
    final detail = detailData?['content'];
    return Scaffold(
      appBar: AppBar(
        title: Text(latinTitle),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(themeC.currentThemeIcon, color: Colors.white),
              tooltip: 'Tema',
              onPressed: () => themeC.changeTheme(),
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.letter_text, color: Colors.white),
            tooltip: 'Preferensi Membaca',
            onPressed: () => ReadingPreferenceDialog.show(context),
          ),
          Obx(
            () => IconButton(
              icon: Icon(
                bookmarkController.isBookmarked(id)
                    ? LucideIcons.bookmark_check
                    : LucideIcons.bookmark_plus,
                color: Colors.white,
              ),
              tooltip: bookmarkController.isBookmarked(id) ? 'Hapus' : 'Simpan',
              onPressed: () {
                bookmarkController.toggleBookmark(id, latinTitle);
              },
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: listItems.length,
        onPageChanged: (index) {
          if (index < 0 || index >= listItems.length) return;
          _onPageChanged(index);
        },
        itemBuilder: (context, index) {
          final item = listItems[index];
          final id = item.id;
          final arabicTitle = item.titleArabic;
          final latinTitle = item.titleLatin;
          final notAvailable = detailData == null;
          final schemaType = detailData?['schema']?['type'] as int?;
          final detail = detailData?['content'];
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                snap: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 80,
                collapsedHeight: 60,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    '\uFD3E $arabicTitle \uFD3F',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'OmarNaskh',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (notAvailable) ...[
                        Text('ID: $id', style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 16),
                        Text(
                          arabicTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'LPMQ-IsepMisbah',
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          latinTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22, height: 1.5),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Data belum tersedia',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ] else ...[
                        JihatiTypeWidget(
                          schemaType: schemaType ?? 0,
                          content: (schemaType == 2 && detail is List)
                              ? List<String>.from(detail)
                              : detail,
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
    );
  }
}
