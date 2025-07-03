import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherPages extends StatelessWidget {
  const OtherPages({super.key});

  // دالة لفتح الرابط
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      throw Exception('Bağlantı açılamadı: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<_LinkItem> items = [
      _LinkItem(
        icon: Icons.podcasts,
        color: Colors.green,
        label: 'Spotify Podcast',
        url: 'https://open.spotify.com/show/3PDrCJDBv8GK7B3slOm9ZE',
      ),
      _LinkItem(
        icon: Icons.menu_book,
        color: Colors.blue,
        label: 'Beykoz Yayınları',
        url: 'https://www.beykoz.edu.tr/icerik/2872-beykoz-yayinlari',
      ),
      _LinkItem(
        icon: Icons.local_library,
        color: Colors.orange,
        label: 'Kütüphane',
        url: 'https://www.beykoz.edu.tr/icerik/3233-kutuphane',
      ),
      _LinkItem(
        icon: Icons.account_balance,
        color: Colors.purple,
        label: 'Kurumsal Kimlik\nKılavuzu',
        url: 'https://www.beykoz.edu.tr/icerik/90-kurumsal-kimlik-kilavuzu',
      ),
      _LinkItem(
        icon: Icons.newspaper,
        color: Colors.red,
        label: 'Basında Beykoz',
        url: 'https://www.beykoz.edu.tr/haber/92-basinda-beykoz',
      ),
      _LinkItem(
        icon: Icons.campaign,
        color: Colors.teal,
        label: 'Basın Bültenleri',
        url: 'https://www.beykoz.edu.tr/icerik/5274-basin-bultenleri',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diğer Sayfa'),
        backgroundColor: const Color(0xFF802629),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Önemli Bağlantılar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: items.map((item) {
                  return InkWell(
                    onTap: () => _launchUrl(item.url),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item.icon, color: item.color, size: 36),
                          const SizedBox(height: 12),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Bu sayfa yapım aşamasındadır.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Yardımcı sınıf: bağlantı verileri
class _LinkItem {
  final IconData icon;
  final Color color;
  final String label;
  final String url;
  const _LinkItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.url,
  });
}
