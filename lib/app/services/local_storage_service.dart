import 'package:get_storage/get_storage.dart';
import 'storage_service.dart';

class LocalStorageService implements StorageService {
  final GetStorage box = GetStorage();
  

  @override
  T? read<T>(String key) {
    return box.read<T>(key);
  }

  @override
  Future<void> write<T>(String key, T value) async {
    await box.write(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await box.remove(key);
  }
}
