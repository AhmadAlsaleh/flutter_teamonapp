class AuthModel {
  String token;
  int userId;

  AuthModel({required this.token, required this.userId});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
    };
  }
}
