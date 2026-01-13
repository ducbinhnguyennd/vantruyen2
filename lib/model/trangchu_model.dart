class Manga {
  String? id;
  String? mangaName;
  String? image;
  String? category;
  int? totalChapters;
  String? author;
  int? view;

  Manga(
      {this.id,
      this.mangaName,
      this.image,
      this.category,
      this.totalChapters,
      this.author,
      this.view});

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
        id: json['id'],
        mangaName: json['manganame'],
        image: json['image'],
        category: json['category'],
        author: json['author'],
        totalChapters: json['totalChapters'],
        view: json['view']);
  }
}
