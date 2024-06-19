class AddUserModel {
  final String fullName;
  final String email;
  final String password;
  final String role;
  final String profession;

  AddUserModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    required this.profession,
  });

  Map<String, dynamic> toJson() => {
        "username": email,
        "fullName": fullName,
        "email": email,
        "password": password,
        "role": role,
        "profession": profession,
        "isActive": true,
      };
}
