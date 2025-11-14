class SurahModel {
  final int id;
  final String name;
  final String translate;
  final String type;
  final int verseCount;
  final int juzId;

  SurahModel({
    required this.id,
    required this.name,
    required this.translate,
    required this.type,
    required this.verseCount,
    required this.juzId,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'] as int,
      name: json['name'] as String,
      translate: json['translate'] as String,
      type: json['type'] as String,
      verseCount: json['verse_count'] as int,
      juzId: json['juz_id'] as int,
    );
  }
}
