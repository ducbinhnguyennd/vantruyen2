class CoinHistory {
  final String id;
  final String content;
  final String user;
  final String userId;
  final String date;
  final String method; // "add" hoặc "sub"
  final int coin;

  CoinHistory.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        content = json['content'],
        user = json['user'],
        userId = json['userid'],
        date = json['date'],
        method = json['method'],
        coin = json['coin'];
}