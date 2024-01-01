class UserDTO {
  final User user;
  final String token;

  UserDTO({required this.user, required this.token});

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      role: json['role'] ?? 'user',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      profileImageUrl: json['profile_image_url'],
    );
  }
}
