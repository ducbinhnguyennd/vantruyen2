
class PaymentHistory {
  final String userID;
  final String currency;
  final double totalAmount;
  final int coin;
  final String date;
  final String success;

  PaymentHistory({
    required this.userID,
    required this.currency,
    required this.totalAmount,
    required this.coin,
    required this.date,
    required this.success,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      userID: json['userID'],
      currency: json['currency'],
      totalAmount: json['totalAmount'].toDouble(),
      coin: json['coin'],
      date: json['date'],
      success: json['success'],
    );
  }
}
