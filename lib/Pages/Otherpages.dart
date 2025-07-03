import 'package:flutter/material.dart';

class OtherPages extends StatelessWidget {
  const OtherPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diğer Sayfa'),
        backgroundColor: const Color(0xFF802629),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Bu sayfa yapım aşamasındadır.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
