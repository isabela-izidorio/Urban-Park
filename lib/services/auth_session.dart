import '../models/app_user.dart';

class AuthSession {
  AuthSession._();

  static AppUser? currentUser;

  static bool get isAuthenticated => currentUser != null;

  static void start(AppUser user) {
    currentUser = user;
  }

  static void end() {
    currentUser = null;
  }
}