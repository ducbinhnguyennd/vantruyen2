import 'package:loginapp/model/trangchu_model.dart';

class NhomdichModel {
  final String userId;
  final String username;
  final String avatar;
  final bool isFollow;
  final int followNumber;
  final int manganumber;
  final List<Manga> manga;
  final List<Bank> bank;

  NhomdichModel({
    required this.userId,
    required this.username,
    required this.avatar,
    required this.isFollow,
    required this.followNumber,
    required this.manganumber,
    required this.bank,
    required this.manga,
  });

  factory NhomdichModel.fromJson(Map<String, dynamic> json) {
    List<Manga> mangaList = (json['manga'] as List)
        .map((mangaJson) => Manga.fromJson(mangaJson))
        .toList();
    List<Bank> bankList = (json['bank'] as List)
        .map((bankJson) => Bank.fromJson(bankJson))
        .toList();
    return NhomdichModel(
      userId: json['userId'],
      username: json['username'],
      avatar: json['avatar'],
      isFollow: json['isfollow'],
      followNumber: json['follownumber'],
      bank: bankList,
      manga: mangaList,
      manganumber: json['manganumber'],
    );
  }
}

class Bank {
  final String hovaten;
  final String phuongthuc;
  final String sotaikhoan;
  final String maQR;

  Bank({
    required this.hovaten,
    required this.phuongthuc,
    required this.sotaikhoan,
    required this.maQR,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
        hovaten: json['hovaten'],
        phuongthuc: json['phuongthuc'],
        sotaikhoan: json['sotaikhoan'],
        maQR: json['maQR']);
  }
}
