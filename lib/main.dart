import 'package:beykoz/Pages/LoginPage.dart';
import 'package:beykoz/Pages/RootPage.dart';
import 'package:beykoz/Services/auth_service.dart';
import 'package:beykoz/Services/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Debug bandını kaldırır
        title: 'Beykoz App',
        theme: ThemeData.light(),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginPage(),
          // Add other named routes here if needed
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (authService.isSignedIn) {
          return const RootScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
