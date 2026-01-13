// user_model.dart
class TopUserModel {
  final String userID;
  final String username;
  final String role;
  final int totalAmount;
  final int coin;
  final String avatar;

  TopUserModel({
    required this.userID,
    required this.username,
    required this.role,
    required this.totalAmount,
    required this.coin,
    required this.avatar
  });

  factory TopUserModel.fromJson(Map<String, dynamic> json) {
    return TopUserModel(
      userID: json['userID'],
      coin: json['coin'],
      username: json['username'],
      role: json['role'],
      totalAmount: json['totalAmount'],avatar: json['avatar']
    );
  }
}
