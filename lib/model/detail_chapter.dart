class ComicChapter {
  final String id;
  final String name;
  final String content;
  final String viporfree;

  final ChapterDetails? nextChap;
  final ChapterDetails? prevChap;

  ComicChapter({
    required this.id,
    required this.name,
    required this.content,
    required this.viporfree,
    this.nextChap,
    this.prevChap,
  });

  factory ComicChapter.fromJson(Map<String, dynamic> json) {
    return ComicChapter(
      id: json['_id'] ?? '',
      name: json['chapname'] ?? '',
      content: json['content'] ?? '',
      viporfree: json['viporfree'] ?? 'free',
      nextChap: json['nextchap'] != null
          ? ChapterDetails.fromJson(json['nextchap'])
          : null,
      prevChap: json['prevchap'] != null
          ? ChapterDetails.fromJson(json['prevchap'])
          : null,
    );
  }
}


class ChapterDetails {
  final String id;
  final String name;
  final String vipOrFree;

  ChapterDetails({
    required this.id,
    required this.name,
    required this.vipOrFree,
  });

  factory ChapterDetails.fromJson(Map<String, dynamic> json) {
    return ChapterDetails(
      id: json['_id'] ?? '',
      name: json['chapname'] ?? '',
      vipOrFree: json['viporfree'] ?? 'free',
    );
  }
}
