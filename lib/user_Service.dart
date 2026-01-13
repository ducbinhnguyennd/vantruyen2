import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserServices {
  final _storage = const FlutterSecureStorage();

  Future<void> saveinfologin(dynamic tcm) async {
    return await _storage.write(key: 'user', value: tcm.toString());
  }

  Future<String> getInfoLogin() async {
    String? info = await _storage.read(key: 'user');
    if (info == null) {
      return "";
    } else {
      return info;
    }
  }

  Future<void> deleteinfo() async {
    return await _storage.delete(key: 'user');
  }

  Future<void> addChuongVuaDocCuaTruyen(
    String chapterid,
    String viporfree,
    String chaptertitle,
    String storyid,
  ) async {
    Map<String, String> content = {
      'idchap': chapterid,
      'titlechap': chaptertitle,
      'viporfree': viporfree
    };
    return await _storage.write(
        key: 'vx_' + storyid, value: convert.jsonEncode(content));
  }

  Future<Future<String?>> readChuongVuaDocOfTruyen(String storyId) async {
    return _storage.read(key: 'vx_$storyId');
  }

  Future<Future<String?>> readTruyenVuaXem(int ipage, int ipagesize) async {
    int skipelement = (ipage - 1) * ipagesize;

    return _storage.read(key: 'vuaxem1');
  }
}
