import 'package:example/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final SharedPreferences _prefs;
  static const String tokenKey = 'token';
  static const String userDataKey = 'user_data';

  AuthService(this._prefs);

  bool get isAuthenticated => _prefs.getString(tokenKey) != null;

  Future<bool> login(String email, String password) async {
    // Mock login - replace with real API call
    if (email == 'admin@example.com' && password == 'password') {
      await _prefs.setString(tokenKey, 'mock_token');
      await _prefs.setString(userDataKey, '{"email": "$email"}');
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _prefs.remove(tokenKey);
    await _prefs.remove(userDataKey);
    // Remove any other auth-related data
    await Get.offAllNamed(Routes.login);
  }
}
