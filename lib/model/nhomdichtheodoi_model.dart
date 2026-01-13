class DichTheoDoiModel {
  final String id;
  final String username;
  final String avatar;

  DichTheoDoiModel({
    required this.id,
    required this.username,
    required this.avatar,
  });

  factory DichTheoDoiModel.fromJson(Map<String, dynamic> json) {
    return DichTheoDoiModel(
      id: json['id'],
      username: json['username'],
      avatar: json['avatar'] ?? "",
    );
  }
}
