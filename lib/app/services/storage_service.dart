abstract class StorageService {
  T? read<T>(String key);
  Future<void> write<T>(String key, T value);
  Future<void> remove(String key);
}
