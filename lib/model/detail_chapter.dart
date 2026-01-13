class ComicChapter {
  final List<String> images;
  final ChapterDetails? nextChap;
  final ChapterDetails? prevChap;
  final String name;
  final String id;

  final String viporfree;

  ComicChapter({
    required this.images,
    this.nextChap,
    this.prevChap,
    required this.id,
    required this.name,
    required this.viporfree
  });

  factory ComicChapter.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['images'] != null) {
      images = List<String>.from(json['images']);
    }

    ChapterDetails? nextChap;
    if (json['nextchap'] != null) {
      nextChap = ChapterDetails.fromJson(json['nextchap']);
    }

    ChapterDetails? prevChap;
    if (json['prevchap'] != null) {
      prevChap = ChapterDetails.fromJson(json['prevchap']);
    }

    return ComicChapter(
      id: json['_id'],
      images: images,
      nextChap: nextChap,
      prevChap: prevChap,
      name: json['chapname'],
      viporfree: json['viporfree']
    );
  }
}

class ChapterDetails {
  final String id;
  final String name;
  final List<String> images;
  final String vipOrFree;

  ChapterDetails({
    required this.id,
    required this.images,
    required this.vipOrFree,
    required this.name
  });

  factory ChapterDetails.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['images'] != null) {
      images = List<String>.from(json['images']);
    }

    return ChapterDetails(
      id: json['_id'],
      name: json['chapname'],
      images: images,
      vipOrFree: json['viporfree'],
    );
  }
}