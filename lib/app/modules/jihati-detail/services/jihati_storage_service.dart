import 'package:get_storage/get_storage.dart';

class JihatiStorageService {
  final _box = GetStorage();

  static const _bookmarkKey = 'jihati_bookmarks';

  List<String> getBookmarks() =>
      _box.read<List<dynamic>>(_bookmarkKey)?.cast<String>() ?? [];
  void saveBookmarks(List<String> ids) => _box.write(_bookmarkKey, ids);
}
