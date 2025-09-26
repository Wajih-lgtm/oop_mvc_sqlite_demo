import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../repositories/base_repository.dart';

/// AuthController: منطق الأعمال (Business Logic) للمصادقة.
/// - يحفظ حالة المستخدم الحالي
/// - يبلّغ الواجهات عبر ChangeNotifier
class AuthController extends ChangeNotifier {
  final AuthRepository _repo;

  User? _currentUser;
  bool _loading = false;
  String? _error;

  AuthController(this._repo);

  User? get currentUser => _currentUser;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _repo.login(email, password);
      if (user == null) {
        _error = 'البريد أو كلمة المرور غير صحيحة.';
        return false;
      }
      _currentUser = user;
      return true;
    } catch (e) {
      _error = 'حدث خطأ أثناء تسجيل الدخول.';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String name, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final existing = await _repo.findByEmail(email);
      if (existing != null) {
        _error = 'هذا البريد مسجّل مسبقًا.';
        return false;
      }
      final user = await _repo.register(email, name, password);
      _currentUser = user;
      return true;
    } catch (e) {
      _error = 'تعذّر إنشاء الحساب.';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
