class UserModel {
  final int id;
  final String fullName;
  final String username;
  final String email;
  final String role;
  final String profession;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.role,
    required this.profession,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        fullName: json['fullName'],
        username: json['username'],
        email: json['email'],
        role: json['role'],
        profession: json['profession'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "fullName": fullName,
        "email": email,
        "role": role,
        "profession": profession,
      };
}
