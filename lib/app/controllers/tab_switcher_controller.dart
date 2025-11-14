import 'package:get/get.dart';

class TabSwitcherController extends GetxController {
  final selectedIndex = 0.obs;

  void switchTab(int index) {
    selectedIndex.value = index;
  }
}
