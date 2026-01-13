class UserResponse {
  bool success;
  Data data;
  String token;

  UserResponse({
    required this.success,
    required this.data,
    required this.token,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'],
      data: Data.fromJson(json['data']),
      token: json['token'],
    );
  }
}

class Data {
  List<UserTSH> user;

  Data({required this.user});

  factory Data.fromJson(Map<String, dynamic> json) {
    var userList = json['user'] as List;
    List<UserTSH> users =
        userList.map((user) => UserTSH.fromJson(user)).toList();
    return Data(user: users);
  }
}

class UserTSH {
  String id;
  String username;
  String password;
  String role;
  int coin;
  String avatar;

  UserTSH(
      {required this.id,
      required this.username,
      required this.password,
      required this.role,
      required this.coin,
      required this.avatar});

  factory UserTSH.fromJson(Map<String, dynamic> json) {
    return UserTSH(
        id: json['_id'],
        username: json['username'],
        password: json['password'],
        role: json['role'],
        coin: json['coin'],
        avatar: json['avatar']);
  }
}
