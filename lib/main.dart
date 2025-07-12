import 'package:beykoz/Pages/LoginPage.dart';
import 'package:beykoz/Pages/RootPage.dart';
import 'package:beykoz/Pages/HomePage.dart';
import 'package:beykoz/Services/auth_service.dart';
import 'package:beykoz/Services/theme_service.dart';
import 'package:beykoz/Services/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'AuthWrapper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeService.currentTheme,
          home: const AuthWrapper(),
          routes: {
            '/login': (context) => const LoginPage(),
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        print('isLoading: [32m${authService.isLoading}[0m, isSignedIn: [32m${authService.isSignedIn}[0m');
        if (authService.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (authService.isSignedIn) {
          return const RootScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
