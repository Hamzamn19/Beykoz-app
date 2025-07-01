import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/LoginPage.dart';
import 'Pages/HomePage.dart';
import 'Services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    if (authService.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (authService.isSignedIn) {
      return const HomeScreen();
    } else {
      return const LoginPage();
    }
  }
}