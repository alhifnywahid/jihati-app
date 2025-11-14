import 'package:get_storage/get_storage.dart';

class QuranStorageService {
  final _box = GetStorage();

  static const _bookmarkKey = 'quran_bookmarks';
  static const _historyKey = 'alquran_history';

  List<String> getBookmarks() =>
      _box.read<List>(_bookmarkKey)?.cast<String>() ?? [];

  void saveBookmarks(List<String> ids) => _box.write(_bookmarkKey, ids);

  List<String> getHistory() =>
      _box.read<List>(_historyKey)?.cast<String>() ?? [];

  void saveHistory(List<String> history) => _box.write(_historyKey, history);
}
