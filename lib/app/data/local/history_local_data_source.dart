import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:jihati/app/models/jihati_item_model.dart';

class HistoryLocalDataSource {
  final GetStorage _storage = GetStorage();
  final String _key = 'jihati_history';

  List<JihatiItem> loadHistory() {
    final raw = _storage.read(_key);
    List<dynamic> historyRaw = [];

    if (raw is String) {
      historyRaw = json.decode(raw);
    } else if (raw is List) {
      historyRaw = raw;
    }

    return historyRaw
        .whereType<Map<String, dynamic>>()
        .map((e) => JihatiItem.fromJson(e))
        .where((item) => item.id != 0 && item.titleLatin.isNotEmpty)
        .toList();
  }

  List<JihatiItem> addToHistory(JihatiItem item) {
    final history = loadHistory();
    history.removeWhere((i) => i.id == item.id);
    history.insert(0, item);
    if (history.length > 6) history.removeLast();
    _storage.write(_key, history.map((e) => e.toJson()).toList());
    return history;
  }

  void clear() {
    _storage.remove(_key);
  }
}
