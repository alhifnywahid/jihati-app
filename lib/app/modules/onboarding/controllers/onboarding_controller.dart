import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jihati/app/models/onboarding.model.dart';
import 'package:jihati/app/routes/app_pages.dart';

class OnboardingController extends GetxController with WidgetsBindingObserver {
  final pageController = PageController();
  final currentPage = 0.obs;
  final RxString textFinish = "Mulai Sekarang".obs;
  final pages = <OnboardingModel>[
    OnboardingModel(
      title: 'Jihati Digital',
      description:
          'Bacaan amaliyah santri kini hadir dalam bentuk digital. Praktis, ringkas, dan siap digunakan di mana saja.',
      imageUrl: 'assets/images/ilustration/onboarding-1.png',
    ),
    OnboardingModel(
      title: 'Selamat Menggunakan!',
      description:
          'Semoga aplikasi ini bermanfaat dan jadi teman amalan harian Anda. Selamat menggunakan Jihati Digital!',
      imageUrl: 'assets/images/ilustration/onboarding-2.png',
    ),
  ].obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> handleNextButton(BuildContext context) async {
    final page = currentPage.value;
    if (page == pages.length - 1) {
      final store = GetStorage();
      store.write("onboarding", true);
      textFinish.value = "Tunggu Sebentar...";
      Future.delayed(Duration(seconds: 2), () {
        Get.offAllNamed(Routes.mainNavigation);
      });
    } else {
      nextPage();
    }
  }
}
