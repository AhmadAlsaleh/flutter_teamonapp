import 'dart:convert';

List<UserModel> usersFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final String profession;
  final bool isActive;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.profession,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        fullName: json['fullName'],
        email: json['email'],
        role: json['role'],
        profession: json['profession'],
        isActive: json['isActive'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "email": email,
        "role": role,
        "profession": profession,
        "isActive": isActive,
      };

  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? role,
    String? profession,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      profession: profession ?? this.profession,
      isActive: isActive ?? this.isActive,
    );
  }
}
