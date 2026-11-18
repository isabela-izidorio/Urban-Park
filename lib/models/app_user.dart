enum UserRole { admin, standard }

class AppUser {
  final String name;
  final String email;
  final String password;
  final UserRole role;

  const AppUser({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? password,
    UserRole? role,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}
