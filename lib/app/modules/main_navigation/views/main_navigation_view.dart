import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jihati/app/modules/main_navigation/views/widgets/list_navigation_widget.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Obx(() => controller.getMenu()["builder"]())),
      bottomNavigationBar: ListNavigation(),
    );
  }
}
