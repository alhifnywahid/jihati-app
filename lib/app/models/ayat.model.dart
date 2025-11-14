class AyatModel {
  int? id;
  int? number;
  String? text;
  int? juzId;
  int? surahId;

  AyatModel({this.id, this.number, this.text, this.juzId, this.surahId});

  AyatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    text = json['text'];
    juzId = json['juz_id'];
    surahId = json['surah_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['number'] = number;
    data['text'] = text;
    data['juz_id'] = juzId;
    data['surah_id'] = surahId;
    return data;
  }
}
