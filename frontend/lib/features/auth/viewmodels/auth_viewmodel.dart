import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../../../core/storage/local_storage.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? errorMessage;

  // ================= LOGIN =================
  Future<void> loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _repository.login(email, password);

      if (res['success'] == true) {
        _user = UserModel.fromJson(res);

        if (_user?.token != null) {
          await LocalStorage.saveToken(_user!.token!);
        }

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showMessage(context, res['message'] ?? 'Login gagal');
      }
    } catch (_) {
      _showMessage(context, 'Server error / IP backend salah');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= REGISTER =================
  Future<void> registerUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _repository.register(email, password);

      if (res['success'] == true) {
        _showMessage(context, 'Registrasi berhasil, silakan login');
        Navigator.pop(context);
      } else {
        _showMessage(context, res['message'] ?? 'Registrasi gagal');
      }
    } catch (_) {
      _showMessage(context, 'Gagal terhubung ke server');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= FORGOT PASSWORD =================
  Future<void> forgotPasswordUser(String email, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _repository.forgotPassword(email);

      if (res['success'] == true) {
        _showMessage(context, 'Kode 5 digit dikirim ke email');
        Navigator.pushNamed(context, '/verify');
      } else {
        _showMessage(context, res['message'] ?? 'Email tidak terdaftar');
      }
    } catch (_) {
      _showMessage(context, 'Cek koneksi / IP backend');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= VERIFY TOKEN =================
  Future<bool> verifyResetToken(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _repository.verifyResetToken(token);

      if (res['success'] == true) {
        return true;
      } else {
        errorMessage = res['message'] ?? 'Token tidak valid';
        return false;
      }
    } catch (_) {
      errorMessage = 'Gagal terhubung ke server';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= RESET PASSWORD =================
  Future<void> resetPasswordUser(
    String token,
    String newPassword,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _repository.resetPassword(token, newPassword);

      if (res['success'] == true) {
        _showMessage(context, 'Password berhasil diubah');
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        _showMessage(context, res['message'] ?? 'Token salah / kadaluwarsa');
      }
    } catch (_) {
      _showMessage(context, 'Gagal reset password');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= LOGOUT =================
  Future<void> logout(BuildContext context) async {
    await LocalStorage.clear();
    _user = null;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

    notifyListeners();
  }

  // ================= HELPER =================
  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}
