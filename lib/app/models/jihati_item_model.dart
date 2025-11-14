import 'package:jihati/utils/logger.util.dart';

class JihatiItem {
  final int id;
  final String titleArabic;
  final String titleLatin;

  JihatiItem({
    required this.id,
    required this.titleArabic,
    required this.titleLatin,
  });

  factory JihatiItem.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'];
      final title = json['title'];

      if (id == null) {
        throw Exception('ID is null');
      }

      if (title == null) {
        throw Exception('Title is null');
      }

      if (title is! Map<String, dynamic>) {
        throw Exception('Title is not Map<String, dynamic>');
      }

      final arabic = title['arabic'];
      final latin = title['latin'];

      return JihatiItem(
        id: id is int ? id : int.tryParse(id.toString()) ?? 0,
        titleArabic: arabic?.toString() ?? '',
        titleLatin: latin?.toString() ?? '',
      );
    } catch (e) {
      logger.e('Error parsing JihatiItem: $e');
      return JihatiItem(id: 0, titleArabic: '', titleLatin: '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': {'arabic': titleArabic, 'latin': titleLatin},
    };
  }
}
