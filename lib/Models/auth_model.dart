class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'vendor',
    );
  }
}

class AuthResponseModel {
  final bool success;
  final UserModel? user;
  final String? token;

  AuthResponseModel({
    required this.success,
    this.user,
    this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      user: json['data'] != null
          ? UserModel.fromJson(json['data']['user'])
          : null,
      token: json['data'] != null
          ? json['data']['token']
          : null,
    );
  }
}