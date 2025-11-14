import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:jihati/app/models/jihati_item_model.dart';
import 'package:jihati/utils/logger.util.dart';

class JihatiLocalDataSource {
  Future<List<JihatiItem>> loadDaftarIsi() async {
    try {
      final response =
          await rootBundle.loadString('assets/data/jihati/0-daftar-isi.json');
      final List<dynamic> data = json.decode(response);
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => JihatiItem.fromJson(e))
          .where((item) => item.id != 0 && item.titleLatin.isNotEmpty)
          .toList();
    } catch (e) {
      logger.e('Error loading daftar isi: $e');
      return [];
    }
  }
}
