class ChangePasswordModel {
  final String email;
  final String currentPassword;
  final String newPassword;

  ChangePasswordModel({
    required this.email,
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) =>
      ChangePasswordModel(
        email: json['email'],
        currentPassword: json['currentPassword'],
        newPassword: json['newPassword'],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      };
}
