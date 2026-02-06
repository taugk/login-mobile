import 'package:flutter/material.dart';
import '../features/auth/views/login_view.dart';
import '../features/auth/views/register_view.dart';
import '../features/auth/views/forgot_password_view.dart';
import '../features/auth/views/verifyToken_view.dart';
import '../features/auth/views/reset_password_view.dart';
import '../features/home/views/home_view.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginView());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case '/forgot':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case '/verify':
        return MaterialPageRoute(builder: (_) => const VerifyTokenView());
      case '/reset':
        final String token = (settings.arguments as String?) ?? "";
        return MaterialPageRoute(
          builder: (_) => ResetPasswordView(token: token),
        );
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginView());
    }
  }
}
