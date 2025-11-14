class VerseModel {
  final int id;
  final int number;
  final int surahId;
  final String text;

  VerseModel({
    required this.id,
    required this.number,
    required this.surahId,
    required this.text,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      id: json['id'] as int,
      number: json['number'] as int,
      surahId: json['surah_id'] as int,
      text: json['text'] as String,
    );
  }
}
