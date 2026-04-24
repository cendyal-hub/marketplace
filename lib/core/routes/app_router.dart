import 'package:flutter/material.dart';
import 'package:marketplace/features/auth/presentation/pages/login_page.dart';
import 'package:marketplace/features/auth/presentation/pages/register_page.dart';
import 'package:marketplace/features/auth/presentation/pages/splash_page.dart';
import 'package:marketplace/features/auth/presentation/pages/verify_email_page.dart';
import 'package:marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:marketplace/features/cart/presentation/pages/cart_page.dart';
import 'package:marketplace/features/cart/presentation/pages/checkout_page.dart';
import 'package:marketplace/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static const String splash    = '/';
  static const String login     = '/login';
  static const String register  = '/register';
  static const String verifyEmail = '/verify-email';
  static const String dashboard = '/dashboard';
  static const String cart      = '/cart';
  static const String checkout  = '/checkout';

  static Map<String, WidgetBuilder> get routes => {
    splash:       (_) => const SplashPage(),
    login:        (_) => const LoginPage(),
    register:     (_) => const RegisterPage(),
    verifyEmail:  (_) => const VerifyEmailPage(),
    dashboard:    (_) => const AuthGuard(child: DashboardPage()),
    cart:         (_) => const AuthGuard(child: CartPage()),
    checkout:     (_) => const AuthGuard(child: CheckoutPage()),
  };
}

/// AuthGuard — proteksi halaman yang butuh autentikasi
/// Redirect ke halaman sesuai status auth
class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthProvider>().status;

    return switch (status) {
      AuthStatus.authenticated      => child,             // Lanjut ke halaman
      AuthStatus.emailNotVerified   => const VerifyEmailPage(), // Verifikasi dulu
      _                             => const LoginPage(), // Login dulu
    };
  }
}
