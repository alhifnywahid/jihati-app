import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:jihati/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:jihati/app/controllers/theme/theme_controller.dart';
import 'package:jihati/app/widgets/jihati_type.widget.dart';
import 'package:jihati/app/widgets/reading_preference_dialog.widget.dart';

class JihatiDetailView extends StatefulWidget {
  const JihatiDetailView({super.key});

  @override
  State<JihatiDetailView> createState() => _JihatiDetailViewState();
}

class _JihatiDetailViewState extends State<JihatiDetailView> {
  late List<dynamic> listItems;
  late int currentIndex;
  late PageController _pageController;
  Map<String, dynamic>? detailData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    listItems = args['listItems'] as List<dynamic>;
    currentIndex = args['currentIndex'] as int? ?? 0;
    _pageController = PageController(initialPage: currentIndex);
    _loadDetail(listItems[currentIndex].id);
  }

  Future<void> _loadDetail(int id) async {
    setState(() => isLoading = true);
    try {
      final raw = await rootBundle.loadString(
        'assets/data/jihati/$id.json',
      );
      final data = json.decode(raw) as Map<String, dynamic>;
      setState(() {
        detailData = data;
        isLoading = false;
      });
    } catch (_) {
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
    final ThemeController themeC = Get.find();
    final item = listItems[currentIndex];
    final id = item.id;
    final latinTitle = item.titleLatin;

    return FScaffold(
      header: FHeader.nested(
        title: Text(latinTitle),
        prefixes: [FHeaderAction.back(onPress: () => Get.back())],
        suffixes: [
          Obx(
            () => FHeaderAction(
              icon: Icon(themeC.currentThemeIcon),
              onPress: () => themeC.cycleTheme(),
            ),
          ),
          FHeaderAction(
            icon: const Icon(FIcons.textCursorInput),
            onPress: () => ReadingPreferenceDialog.show(context),
          ),
          Obx(
            () => FHeaderAction(
              icon: Icon(
                bookmarkController.isBookmarked(id)
                    ? FIcons.bookmarkCheck
                    : FIcons.bookmarkPlus,
              ),
              onPress: () => bookmarkController.toggleBookmark(id, latinTitle),
            ),
          ),
        ],
      ),
      child: PageView.builder(
        controller: _pageController,
        itemCount: listItems.length,
        onPageChanged: (index) {
          if (index < 0 || index >= listItems.length) return;
          _onPageChanged(index);
        },
        itemBuilder: (context, index) {
          final pageItem = listItems[index];
          final arabicTitle = pageItem.titleArabic;
          final pageLatinTitle = pageItem.titleLatin;

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
                      if (detailData == null) ...[
                        Text(
                          'ID: ${pageItem.id}',
                          style: const TextStyle(fontSize: 18),
                        ),
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
                          pageLatinTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22, height: 1.5),
                        ),
                        const SizedBox(height: 32),
                        const FAlert(
                          icon: Icon(FIcons.circleAlert),
                          title: Text('Data belum tersedia'),
                        ),
                      ] else ...[
                        Obx(
                          () => JihatiTypeWidget(
                            schemaType:
                                detailData!['schema']?['type'] as int? ?? 0,
                            content: detailData!['content'],
                          ),
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
