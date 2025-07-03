import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class TransportationPage extends StatelessWidget {
  const TransportationPage({super.key});

  // تعريف الألوان الرئيسية لضمان التناسق مع الصفحة الرئيسية
  static const Color primaryColor = Color(0xFF802629);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ulaşım ve İletişim'),
          // 1. تغيير لون شريط العنوان ليتطابق مع الصفحة الرئيسية
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.contact_phone_outlined), text: 'İletişim'),
              Tab(icon: Icon(Icons.location_city_outlined), text: 'Kampüsler'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildContactInfoTab(context), _buildCampusesTab()],
        ),
      ),
    );
  }

  // ويدجت بناء تاب معلومات الاتصال
  Widget _buildContactInfoTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          "Genel İletişim Bilgileri",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            // 2. تغيير لون العنوان ليتطابق مع اللون الرئيسي
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildContactTile(
                context,
                Icons.phone_outlined,
                "Telefon",
                "0216 912 22 52",
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildContactTile(
                context,
                Icons.print_outlined,
                "Faks",
                "0216 413 95 20",
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildContactTile(
                context,
                Icons.email_outlined,
                "E-Posta",
                "bilgi@beykoz.edu.tr",
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildContactTile(
                context,
                Icons.person_outline,
                "Aday Öğrenciler",
                "tercih@beykoz.edu.tr",
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildContactTile(
                context,
                Icons.message_outlined,
                "WhatsApp",
                "0530 230 52 46",
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ويدجت بناء تاب معلومات الحرم الجامعي
  Widget _buildCampusesTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      children: [
        _CampusExpansionTile(
          title: "Rektörlük Yerleşkesi",
          address:
              "Orhan Veli Kanık Caddesi No:114, 34810 Kavacık-Beykoz/İstanbul",
          mapsUrl: "https://maps.app.goo.gl/yri12V8vGP8RgwLN8",
        ),
        _CampusExpansionTile(
          title: "Kavacık Yerleşkesi",
          address: "Vatan Caddesi No: 69 PK: 34805 Kavacık - Beykoz / İstanbul",
          mapsUrl: "https://maps.app.goo.gl/wosE547jewnYBj7r8",
          children: const [
            "Lisansüstü Programlar Enstitüsü",
            "İşletme ve Yönetim Bilimleri Fakültesi",
            "Sosyal Bilimler Fakültesi",
            "Sivil Havacılık Yüksekokulu",
            "Beykoz Lojistik Meslek Yüksekokulu",
          ],
        ),
        _CampusExpansionTile(
          title: "Lisans Yerleşkesi",
          address: "Muhtar Sokak No: 3 Kavacık - Beykoz / İstanbul",
          mapsUrl: "https://maps.app.goo.gl/cavh2PwNeuPEtqf18",
          children: const [
            "Sanat ve Tasarım Fakültesi (Gastronomi ve Mutfak Sanatları Lisans Programı Öğrencileri Hariç)",
            "Mühendislik ve Mimarlık Fakültesi",
          ],
        ),
        _CampusExpansionTile(
          title: "Lisans Programları Laboratuvar ve Atölyeler",
          address: "Ertürk Sokak No: 6 Kavacık - Beykoz / İstanbul",
          mapsUrl: "https://maps.app.goo.gl/ybN5vyfouLiPyryh6",
          children: const [
            "Çizim Atölyesi",
            "Sayısal Sistemler Laboratuvarı",
            "Fizik Laboratuvarı",
            "Gömülü Sistemler Laboratuvarı",
            "Üretim Sistemleri ve Robotik Laboratuvarı",
            "Klinik Psikoloji Uygulama Merkezi",
          ],
        ),
        _CampusExpansionTile(
          title: "Hazırlık Yerleşkesi",
          address:
              "Fatih Sultan Mehmet Cadddesi Şehit Er Cengiz Karcıoğlu Sk. No: 7 34810 Kavacık Beykoz İstanbul",
          mapsUrl: "https://maps.app.goo.gl/Zcd7bYrfKdjsRZnn6",
          children: const [
            "İngilizce Hazırlık Programı",
            "Gastronomi ve Mutfak Sanatları Lisans Programı",
            "Aşçılık Önlisans Programı",
          ],
        ),
      ],
    );
  }

  // ويدجت مساعدة لبناء صفوف معلومات الاتصال
  Widget _buildContactTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return ListTile(
      // 3. تغيير لون الأيقونات ليتطابق مع اللون الرئيسي
      leading: Icon(icon, color: primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.black54)),
      trailing: const Icon(Icons.copy_outlined, size: 20, color: Colors.grey),
      onTap: () {
        Clipboard.setData(ClipboardData(text: subtitle));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // 4. ترجمة رسالة التأكيد إلى اللغة التركية
            content: Text('"$subtitle" panoya kopyalandı.'),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(10),
          ),
        );
      },
    );
  }
}

// ويدجت بطاقة الحرم الجامعي القابلة للتوسيع
class _CampusExpansionTile extends StatelessWidget {
  final String title;
  final String address;
  final String mapsUrl;
  final List<String> children;

  const _CampusExpansionTile({
    required this.title,
    required this.address,
    required this.mapsUrl,
    this.children = const [],
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // استخدام اللون الرئيسي من الصفحة الرئيسية
    const Color primaryColor = Color(0xFF802629);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: const Icon(Icons.business_outlined, color: primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            address,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (children.isNotEmpty)
            ...children.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ", style: TextStyle(color: Colors.grey)),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => _launchUrl(mapsUrl),
                icon: const Icon(Icons.map_outlined, size: 18),
                // نص الزر باللغة التركية
                label: const Text("Haritada Görüntüle"),
                // 5. تغيير ألوان الزر لتتطابق مع هوية الصفحة الرئيسية
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor.withOpacity(0.1),
                  foregroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
