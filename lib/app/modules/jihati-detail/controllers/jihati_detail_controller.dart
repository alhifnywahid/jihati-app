import 'package:get/get.dart';
import 'package:jihati/app/models/jihati_item_model.dart';
import 'package:jihati/app/modules/history/controllers/history_controller.dart';

class JihatiDetailController extends GetxController {
  late int id;
  late String arabicTitle;
  late String latinTitle;
  late Map<String, dynamic> args;

  @override
  void onInit() {
    super.onInit();
    args = (Get.arguments ?? <String, dynamic>{}) as Map<String, dynamic>;
    id = args['id'] ?? 0;
    arabicTitle = args['arabicTitle'] ?? '';
    latinTitle = args['latinTitle'] ?? '';

    // Hanya history, bookmark dipisah
    final historyController = Get.find<HistoryController>();
    historyController.addToHistory(
      JihatiItem(id: id, titleArabic: arabicTitle, titleLatin: latinTitle),
    );
  }
}
