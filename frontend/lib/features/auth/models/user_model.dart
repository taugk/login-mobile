class UserModel {
  final int id;
  final String email;
  final String? token;

  UserModel({required this.id, required this.email, this.token});

  // Mapping dari JSON backend ke Object Flutter
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'],
      email: json['user']['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'token': token};
  }
}
