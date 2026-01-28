class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    fullName: json['fullName'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
  );
}
