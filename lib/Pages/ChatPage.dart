// lib/Pages/ChatPage.dart

import 'package:beykoz/Services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Belirli bir kişiyle olan sohbeti gösteren sayfa.
class ChatPage extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const ChatPage({
    super.key,
    required this.name,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final primaryColor = themeService.isDarkMode
        ? ThemeService.darkPrimaryColor
        : ThemeService.lightPrimaryColor;

    return Scaffold(
      backgroundColor: themeService.isDarkMode ? Colors.black : const Color(0xFFE8E5DA),
      // App Bar (Başlık Çubuğu)
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 1.0,
        // Başlıkta kişinin avatarı ve adı yer alıyor.
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.9),
              child: Text(
                avatarUrl,
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Text(name, style: const TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Gelecekte eklenecek menü fonksiyonu
            },
          ),
        ],
      ),
      // Sayfa içeriği
      body: Column(
        children: [
          // Mesajların listelendiği alan
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12.0),
              children: const [
                // Sahte mesaj balonları
                _MessageBubble(
                  text: 'Merhaba, projenin son durumu hakkında bilgi alabilir miyim?',
                  isMe: false, // Karşıdan gelen mesaj
                  time: '10:42',
                ),
                _MessageBubble(
                  text: 'Tabii ki, raporu hazırlıyorum. Kısa sürede göndereceğim.',
                  isMe: true, // Bizim gönderdiğimiz mesaj
                  time: '10:43',
                ),
                _MessageBubble(
                  text: 'Teşekkür ederim, bekliyorum.',
                  isMe: false,
                  time: '10:44',
                ),
                _MessageBubble(
                  text: 'Rapor gönderildi. Kontrol edebilir misiniz?',
                  isMe: true,
                  time: '10:45',
                ),
              ],
            ),
          ),
          // Mesaj yazma alanı (işlevsel değil)
          _buildMessageComposer(context),
        ],
      ),
    );
  }

  // Mesaj yazma alanını oluşturan özel widget.
  Widget _buildMessageComposer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      color: Colors.transparent, // Arka planı sayfa rengiyle aynı yapar
      child: SafeArea(
        child: Row(
          children: [
            // Metin giriş alanı
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        enabled: false, // Yazmayı engeller
                        decoration: InputDecoration(
                          hintText: 'Mesaj yazın...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Gönder butonu
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: Provider.of<ThemeService>(context).isDarkMode
                    ? ThemeService.darkPrimaryColor
                    : ThemeService.lightPrimaryColor,
                padding: const EdgeInsets.all(12),
              ),
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: null, // Butonu pasif yapar
            ),
          ],
        ),
      ),
    );
  }
}

// Mesaj balonlarını oluşturan özel widget.
class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe; // Mesajın bize mi ait olduğunu belirtir
  final String time;

  const _MessageBubble({
    required this.text,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      // Mesajı bize aitse sağa, değilse sola hizalar.
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          // Mesajın sahibine göre renk değiştirir.
          color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(text, style: const TextStyle(color: Colors.black87, fontSize: 16)),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}