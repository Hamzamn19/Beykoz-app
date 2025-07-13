// lib/Pages/MessengerPage.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beykoz/Services/theme_service.dart';
import 'package:beykoz/Pages/ChatPage.dart';

class MessengerPage extends StatelessWidget {
  const MessengerPage({super.key});

  final List<Map<String, String>> _dummyChats = const [
    {
      "name": "Prof. Dr. Ahmet Yılmaz",
      "message": "Merhaba, projenin son durumu hakkında bilgi alabilir miyim?",
      "time": "10:45",
      "avatarUrl": "AY",
      "unreadCount": "2",
    },
    {
      "name": "Öğrenci İşleri",
      "message": "Ders kaydınız onaylanmıştır. Başarılar dileriz.",
      "time": "09:30",
      "avatarUrl": "Öİ",
      "unreadCount": "0",
    },
    {
      "name": "Dr. Elif Kaya",
      "message": "Yarınki dersimiz saat 11:00'de başlayacak.",
      "time": "Dün",
      "avatarUrl": "EK",
      "unreadCount": "0",
    },
    {
      "name": "Kantin",
      "message": "Haftanın menüsü güncellendi, afiyet olsun!",
      "time": "Dün",
      "avatarUrl": "K",
      "unreadCount": "1",
    },
  ];

  void _showNewChatSheet(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    final primaryColor = themeService.isDarkMode
        ? ThemeService.darkPrimaryColor
        : ThemeService.lightPrimaryColor;
    final sheetBackgroundColor = themeService.isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    // --- ARAMA ÇUBUĞU İÇİN YENİ RENK ---
    final searchBarColor = themeService.isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade200;

    final List<Map<String, String>> dummyContacts = const [
      { "name": "Doç. Dr. Zeynep Aksoy", "avatar": "ZA" },
      { "name": "Mehmet Can", "avatar": "MC" },
      { "name": "Kariyer Merkezi", "avatar": "KM" },
      { "name": "Ayşe Demir", "avatar": "AD" },
      { "name": "Teknik Destek", "avatar": "TD" },
      { "name": "Öğr. Gör. Ali Veli", "avatar": "AV" },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: sheetBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Sohbet Başlat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeService.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              // --- YENİ ARAMA ÇUBUĞU WIDGET'I ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  // İşlevsel olmayacağı için onChanged veya controller yok.
                  // enabled: false, // Görsel olarak pasif bırakmak isterseniz bunu açın.
                  decoration: InputDecoration(
                    hintText: 'Kişi ara...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    filled: true,
                    fillColor: searchBarColor,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // Kenar çizgisi yok
                    ),
                  ),
                ),
              ),
              // --- ARAMA ÇUBUĞU BİTTİ ---
              Expanded(
                child: ListView.builder(
                  itemCount: dummyContacts.length,
                  itemBuilder: (context, index) {
                    final contact = dummyContacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Text(
                          contact['avatar']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(contact['name']!),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              name: contact['name']!,
                              avatarUrl: contact['avatar']!,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final primaryColor = themeService.isDarkMode
        ? ThemeService.darkPrimaryColor
        : ThemeService.lightPrimaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesajlar'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: ListView.builder(
        itemCount: _dummyChats.length,
        itemBuilder: (context, index) {
          final chat = _dummyChats[index];
          final hasUnreadMessages =
              int.tryParse(chat['unreadCount'] ?? '0')! > 0;

          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: primaryColor.withOpacity(0.8),
                  child: Text(
                    chat['avatarUrl']!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  chat['name']!,
                  style: TextStyle(
                    fontWeight: hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  chat['message']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat['time']!,
                      style: TextStyle(
                        color: hasUnreadMessages ? Colors.green : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (hasUnreadMessages)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          chat['unreadCount']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        name: chat['name']!,
                        avatarUrl: chat['avatarUrl']!,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                height: 1,
                indent: 80,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewChatSheet(context);
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.chat),
        tooltip: 'Yeni Sohbet',
      ),
    );
  }
}