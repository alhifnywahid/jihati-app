import 'package:get/get.dart';

import '../modules/aboutme/bindings/aboutme_binding.dart';
import '../modules/aboutme/views/aboutme_view.dart';
import '../modules/accountme/bindings/accountme_binding.dart';
import '../modules/accountme/views/accountme_view.dart';
import '../modules/bookmark/bindings/bookmark_binding.dart';
import '../modules/bookmark/views/bookmark_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/jihati-detail/bindings/jihati_detail_binding.dart';
import '../modules/jihati-detail/views/jihati_detail_view.dart';
import '../modules/jihati/bindings/jihati_binding.dart';
import '../modules/jihati/views/jihati_view.dart';
import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/quran-detail/bindings/quran_detail_binding.dart';
import '../modules/quran-detail/views/quran_detail_view.dart';
import '../modules/quran/bindings/quran_binding.dart';
import '../modules/quran/views/quran_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.introduction;

  static final routes = [
    GetPage(
      name: _Paths.mainNavigation,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: _Paths.introduction,
      page: () => const IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.jihati,
      page: () => const JihatiView(),
      binding: JihatiBinding(),
    ),
    GetPage(
      name: _Paths.setting,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.quran,
      page: () => const QuranView(),
      binding: QuranBinding(),
    ),
    GetPage(
      name: _Paths.aboutme,
      page: () => const AboutmeView(),
      binding: AboutmeBinding(),
    ),
    GetPage(
      name: _Paths.bookmark,
      page: () => const BookmarkView(),
      binding: BookmarkBinding(),
    ),
    GetPage(
      name: _Paths.history,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.accountme,
      page: () => const AccountmeView(),
      binding: AccountmeBinding(),
    ),
    GetPage(
      name: _Paths.jihatiDetail,
      page: () => const JihatiDetailView(),
      binding: JihatiDetailBinding(),
    ),
    GetPage(
      name: _Paths.quranDetail,
      page: () => const QuranDetailView(),
      binding: QuranDetailBinding(),
    ),
    GetPage(
      name: _Paths.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
  ];
}
