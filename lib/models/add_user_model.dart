class AddUserModel {
  final String? fullName;
  final String? email;
  final String? password;
  final String? role;
  final String? profession;
  final double? salary;
  final double? workHours;
  final double? breakHours;
  final String? workdays;

  AddUserModel({
    this.fullName,
    this.email,
    this.password,
    this.role,
    this.profession,
    this.salary,
    this.workHours,
    this.breakHours,
    this.workdays,
  });

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "password": password,
        "role": role,
        "profession": profession,
        "isActive": true,
        "salary": salary,
        "workHours": workHours,
        "breakHours": breakHours,
        "workdays": workdays,
      };

  AddUserModel copyWith({
    String? fullName,
    String? email,
    String? password,
    String? role,
    String? profession,
    double? salary,
    double? workHours,
    double? breakHours,
    String? workdays,
  }) {
    return AddUserModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      profession: profession ?? this.profession,
      salary: salary ?? this.salary,
      workHours: workHours ?? this.workHours,
      breakHours: breakHours ?? this.breakHours,
      workdays: workdays ?? this.workdays,
    );
  }
}
