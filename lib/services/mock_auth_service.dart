import '../models/app_user.dart';

/// Serviço demonstrativo de autenticação. Substituir pela API/Firebase futuramente.
class MockAuthService {
  static final List<AppUser> _users = [
    const AppUser(
      name: 'Administrador',
      email: 'admin@urbanpark.com',
      password: 'admin123',
      role: UserRole.admin,
    ),
    const AppUser(
      name: 'Usuário Urban Park',
      email: 'usuario@urbanpark.com',
      password: '123456',
      role: UserRole.standard,
    ),
    const AppUser(
      name: 'Usuário 2',
      email: 'usuario2@urbanpark.com',
      password: '123456',
      role: UserRole.standard,
    ),
  ];

  List<AppUser> get users => List<AppUser>.unmodifiable(_users);

  Future<AppUser?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 250));
    try {
      return _users.firstWhere(
        (user) =>
            user.email.toLowerCase() == email.trim().toLowerCase() &&
            user.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final normalizedEmail = email.trim().toLowerCase();
    final exists = _users.any(
      (user) => user.email.toLowerCase() == normalizedEmail,
    );
    if (exists) return false;

    _users.add(AppUser(
      name: name.trim(),
      email: normalizedEmail,
      password: password,
      role: UserRole.standard,
    ));
    return true;
  }

  bool updateRole(String email, UserRole role) {
    final index = _users.indexWhere(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    );
    if (index < 0) return false;
    _users[index] = _users[index].copyWith(role: role);
    return true;
  }

  bool deleteUser(String email) {
    final index = _users.indexWhere(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    );
    if (index < 0) return false;
    _users.removeAt(index);
    return true;
  }
}
