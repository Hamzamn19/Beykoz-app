import 'package:beykoz/RootScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'home.dart'; // Eğer 'home.dart' dosyan varsa kalsın, yoksa silebilirsin.
import 'login_page.dart'; // LoginPage'i import etmeyi unutma!
import 'auth_service.dart';

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
        home: const RootScreen(),
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
