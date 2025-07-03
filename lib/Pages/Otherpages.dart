import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Transportation.dart'; // تأكد من أن هذا الملف موجود وصحيح

class OtherPages extends StatelessWidget {
  const OtherPages({super.key});

  // دالة لفتح الرابط، لم تتغير
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      throw Exception('Bağlantı açılamadı: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // قائمة جديدة من العناصر باستخدام الفئة المساعدة الجديدة
    // لاحظ أن كل عنصر يحدد دالة onTap الخاصة به
    final List<_ActionItem> items = [
      _ActionItem(
        icon: Icons.podcasts,
        color: Colors.green,
        label: 'Spotify Podcast',
        onTap: () =>
            _launchUrl('https://open.spotify.com/show/3PDrCJDBv8GK7B3slOm9ZE'),
      ),
      _ActionItem(
        icon: Icons.menu_book,
        color: Colors.blue,
        label: 'Beykoz Yayınları',
        onTap: () => _launchUrl(
          'https://www.beykoz.edu.tr/icerik/2872-beykoz-yayinlari',
        ),
      ),
      _ActionItem(
        icon: Icons.local_library,
        color: Colors.orange,
        label: 'Kütüphane',
        onTap: () =>
            _launchUrl('https://www.beykoz.edu.tr/icerik/3233-kutuphane'),
      ),
      _ActionItem(
        icon: Icons.account_balance,
        color: Colors.purple,
        label: 'Kurumsal Kimlik\nKılavuzu',
        onTap: () => _launchUrl(
          'https://www.beykoz.edu.tr/icerik/90-kurumsal-kimlik-kilavuzu',
        ),
      ),
      _ActionItem(
        icon: Icons.newspaper,
        color: Colors.red,
        label: 'Basında Beykoz',
        onTap: () =>
            _launchUrl('https://www.beykoz.edu.tr/haber/92-basinda-beykoz'),
      ),
      _ActionItem(
        icon: Icons.campaign,
        color: Colors.teal,
        label: 'Basın Bültenleri',
        onTap: () => _launchUrl(
          'https://www.beykoz.edu.tr/icerik/5274-basin-bultenleri',
        ),
      ),
      // -- العنصر الجديد المضاف --
      // هذا العنصر يقوم بالانتقال إلى صفحة أخرى بدلاً من فتح رابط
      _ActionItem(
        icon: Icons.directions_bus,
        color: const Color(0xFF0A285F), // نفس لون الزر القديم
        label: 'Ulaşım Bilgileri',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransportationPage()),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diğer Sayfalar',
        ), // تم تعديل العنوان ليعكس المحتوى بشكل أفضل
        backgroundColor: const Color(0xFF802629),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
        child: Column(
          children: [
            const Text(
              'Önemli Bağlantılar ve Servisler', // تم تعديل العنوان
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // الآن الشبكة هي العنصر الوحيد القابل للتوسيع وتملأ المساحة
            Expanded(
              child: GridView.builder(
                // استخدام GridView.builder لتحسين الأداء إذا كانت القائمة كبيرة
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // عدد الأعمدة
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio:
                      1.1, // يمكنك تعديل هذه النسبة لتغيير ارتفاع العناصر
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InkWell(
                    // استدعاء دالة onTap الخاصة بالعنصر عند الضغط عليه
                    onTap: item.onTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item.icon, color: item.color, size: 40),
                          const SizedBox(height: 12),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -- الفئة المساعدة الجديدة --
// هذه الفئة تصف أي عنصر قابل للتنفيذ في الشبكة
// تحتوي على أيقونة ولون وعنوان ودالة (onTap) لتنفيذها عند الضغط
class _ActionItem {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap; // دالة لا ترجع قيمة ولا تأخذ متغيرات

  const _ActionItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });
}
