import '../models/app_user.dart';

/// Simula o backend. Depois, substitua o conteúdo pelos métodos HTTP da API.
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
  ];

  Future<AppUser?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    try {
      return _users.firstWhere(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase()
            && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final exists = _users.any(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
    );
    if (exists) return false;

    // Cadastro público nunca cria administrador.
    _users.add(AppUser(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
      role: UserRole.standard,
    ));
    return true;
  }
}
