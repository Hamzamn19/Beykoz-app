import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home.dart'; // Eğer 'home.dart' dosyan varsa kalsın, yoksa silebilirsin.
import 'login_page.dart'; // LoginPage'i import etmeyi unutma!

void main() async {
  // Flutter binding'lerinin Firebase'den önce başlatıldığından emin ol.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug bandını kaldırır
      title: 'Beykoz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Uygulama başladığında LoginPage'i göster.
      home: const LoginPage(), // Burası artık LoginPage'i gösterecek!
    );
  }
}
