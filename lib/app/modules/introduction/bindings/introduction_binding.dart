import 'package:get/get.dart';
import 'package:jihati/app/modules/onboarding/controllers/onboarding_controller.dart';

import '../controllers/introduction_controller.dart';

class IntroductionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroductionController>(() => IntroductionController());
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}
