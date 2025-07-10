import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AcademicStaffPage extends StatefulWidget {
  const AcademicStaffPage({super.key});

  @override
  State<AcademicStaffPage> createState() => _AcademicStaffPageState();
}

class _AcademicStaffPageState extends State<AcademicStaffPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  // URL açma fonksiyonu
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Hata durumunda kullanıcıya bilgi ver
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Web sayfası açılamadı: $url'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Tamam',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata oluştu: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Tamam',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 24),
                    _buildStatsCard(),
                    const SizedBox(height: 24),
                    _buildFacultiesSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Akademik Kadro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3.0,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF802629), Color(0xFF9D3034), Color(0xFF802629)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF802629), Color(0xFF9D3034)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF802629).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fakülteler ve Akademik Birimler',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF802629),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Fakülteler ve Yüksekokullar',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('8', 'Birim', Icons.account_balance),
          _buildStatItem('32', 'Akademisyen', Icons.person),
          _buildStatItem('12', 'Profesör', Icons.workspace_premium),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF802629).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF802629), size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF802629),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildFacultiesSection() {
    final faculties = [
      FacultyData(
        'İşletme ve Yönetim Bilimleri Fakültesi',
        Icons.business_center,
        const LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF357ABD)]),
        [
          PersonData(
            name: 'Prof. Dr. Ayşe Yılmaz (Dekan)',
            about: 'İşletme Yönetimi alanında uzmandır.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/ayse_yilmaz.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Can Demir',
            about: 'Pazarlama stratejileri üzerine çalışmaktadır.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/can_demir.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Elif Kaya',
            about: 'İnsan kaynakları yönetimi konularında ders vermektedir.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/elif_kaya.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Mert Coşkun',
            about:
                'Girişimcilik ve inovasyon üzerine araştırmalar yapmaktadır.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/mert_coskun.pdf',
          ),
        ],
        'https://www.beykoz.edu.tr/kadro/isletme-ve-yonetim-bilimleri-fakultesi-akademik-kadro',
      ),
      FacultyData(
        'Sosyal Bilimler Fakültesi',
        Icons.groups,
        const LinearGradient(colors: [Color(0xFF26A69A), Color(0xFF00695C)]),
        [
          PersonData(
            name: 'Prof. Dr. Zeynep Arslan (Dekan)',
            about: 'Sosyoloji ve kültür araştırmaları alanında tanınmıştır.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/zeynep_arslan.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Burak Tekin',
            about: 'Politika bilimi ve uluslararası ilişkiler uzmanıdır.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/burak_tekin.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Gamze Şahin',
            about: 'Psikoloji ve bilişsel bilimler üzerine çalışmaktadır.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/gamze_sahin.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Deniz Aksoy',
            about:
                'Eğitim bilimleri ve öğretim teknolojileri üzerine yoğunlaşmıştır.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/deniz_aksoy.pdf',
          ),
        ],
        'https://www.beykoz.edu.tr/kadro/sbf-akademik-kadro',
      ),
      FacultyData(
        'Mühendislik ve Mimarlık Fakültesi',
        Icons.architecture,
        const LinearGradient(colors: [Color(0xFFFF7043), Color(0xFFD84315)]),
        [
          PersonData(
            name: 'Prof. Dr. Ragıp Kutay KARACA',
            about: 'Dekan Vekili',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/949.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Tansel KORKMAZ',
            about: 'Mimarlık Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/889.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi İnal Begüm TURNA DEMİREL',
            about: 'Dekan Yardımcısı/ Bilgisayar Mühendisliği Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/693.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Serra Gül',
            about:
                'Elektrik-elektronik mühendisliği ve sinyal işleme üzerine çalışmaktadır.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/serra_gul.pdf',
          ),
        ],
        'https://www.beykoz.edu.tr/kadro/mmf-akademik-kadro',
      ),
      FacultyData(
        'Sanat ve Tasarım Fakültesi',
        Icons.palette,
        const LinearGradient(colors: [Color(0xFF8E24AA), Color(0xFF6A1B9A)]),
        [
          PersonData(
            name: 'Prof. Dr. Didem Kurt (Dekan)',
            about:
                'Grafik tasarım ve görsel iletişimde önde gelen isimlerdendir.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/didem_kurt.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Alper Sönmez',
            about: 'Endüstriyel tasarım ve ürün geliştirme konusunda uzmandır.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/alper_sonmez.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Nazlı Can',
            about:
                'İç mimarlık ve mekan tasarımı alanında dersler vermektedir.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/nazli_can.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Fatih Kaplan',
            about:
                'Moda tasarımı ve tekstil sanatları üzerine araştırmalar yapmaktadır.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/fatih_kaplan.pdf',
          ),
        ],
        'https://www.beykoz.edu.tr/kadro/stf-akademik-kadro',
      ),
      FacultyData(
        'Beykoz Lojistik Meslek Yüksekokulu',
        Icons.local_shipping,
        const LinearGradient(colors: [Color(0xFF43A047), Color(0xFF2E7D32)]),
        [
          PersonData(
            name: 'Prof. Dr. Mehmet Özkan (Müdür)',
            about: 'Lojistik ve tedarik zinciri yönetimi konusunda deneyimli.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/mehmet_ozkan.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Sibel Kırık',
            about: 'Uluslararası taşımacılık ve gümrükleme üzerine çalışıyor.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/sibel_kirik.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Hasan Yalçın',
            about: 'Depo yönetimi ve envanter kontrolü dersleri veriyor.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/hasan_yalcin.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Aylin Öztürk',
            about: 'Lojistik teknolojileri ve yazılımları üzerine odaklanmış.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/aylin_ozturk.pdf',
          ),
        ],
        'https://www.beykoz.edu.tr/kadro/blmyo-akademik-kadro',
      ),
      FacultyData(
        'Yabancı Diller Yüksekokulu',
        Icons.language,
        const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFC2185B)]),
        [
          PersonData(
            name: 'Prof. Dr. Sarah Johnson (Müdür)',
            about: 'İngiliz dili ve edebiyatı uzmanı.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/sarah_johnson.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Maria Garcia',
            about:
                'İspanyolca ve dil öğrenme metodolojileri üzerine çalışıyor.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/maria_garcia.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Jean Pierre',
            about: 'Fransızca dilbilgisi ve kültürü dersleri veriyor.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/jean_pierre.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Kemal Erdoğan',
            about: 'Türkçe yabancı dil olarak öğretimi üzerine odaklanmış.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/kemal_erdogan.pdf',
          ),
        ],
        'https://www.beykoz.edu.tr/kadro/ydy-akademik-kadro',
      ),
      FacultyData(
        'Meslek Yüksekokulu',
        Icons.work,
        const LinearGradient(colors: [Color(0xFF795548), Color(0xFF5D4037)]),
        [
          PersonData(
            name: 'Prof. Dr. Ahmet Demir (Müdür)',
            about: 'Elektronik ve otomasyon sistemleri uzmanı.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/ahmet_demir.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Fatma Koç',
            about:
                'Bilgisayar programcılığı ve web geliştirme üzerine çalışıyor.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/fatma_koc.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Osman Kara',
            about: 'Muhasebe ve finans uygulamaları dersleri veriyor.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/osman_kara.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Zehra Aktaş',
            about: 'Sağlık hizmetleri yönetimi ve etik üzerine odaklanmış.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/zehra_aktas.pdf',
          ),
        ],
        'https://www.beykoz.edu.tr/kadro/myo-akademik-kadro',
      ),
      FacultyData(
        'Sivil Havacılık Yüksekokulu',
        Icons.flight,
        const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF1976D2)]),
        [
          PersonData(
            name: 'Prof. Dr. Pilot Cenk Uçar (Müdür)',
            about: 'Havacılık yönetimi ve pilotajda deneyimli.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/cenk_ucar.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Ayşegül Havacı',
            about:
                'Hava trafik kontrolü ve güvenlik sistemleri üzerine çalışıyor.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/aysegul_havaci.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Mert Skywalker',
            about: 'Uçak bakım ve onarım teknolojileri dersleri veriyor.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/mert_skywalker.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Gökhan Jetli',
            about: 'Kabın hizmetleri ve yolcu güvenliği üzerine odaklanmış.',
            cvUrl: 'https://www.beykoz.edu.tr/cv/gokhan_jetli.pdf',
          ),
        ],
        'https://www.beykoz.edu.tr/kadro/shy-akademik-kadro',
      ),
    ];

    return Column(
      children: faculties.asMap().entries.map((entry) {
        final index = entry.key;
        final faculty = entry.value;

        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildFacultyCard(faculty),
        );
      }).toList(),
    );
  }

  Widget _buildFacultyCard(FacultyData faculty) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: faculty.gradient.colors.first.withOpacity(0.1),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            childrenPadding: const EdgeInsets.only(bottom: 16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: faculty.gradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: faculty.gradient.colors.first.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(faculty.icon, color: Colors.white, size: 24),
            ),
            title: Text(
              faculty.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${faculty.staff.length} akademisyen',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                GestureDetector(
                  onTap: () =>
                      _launchURL(faculty.webUrl), // Fakülte geneli CV'leri için
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: faculty.gradient.colors.first.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: faculty.gradient.colors.first.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.link, // Daha genel bir link ikonu
                          size: 14,
                          color: faculty.gradient.colors.first,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Fakülte Sayfası', // Metin güncellendi
                          style: TextStyle(
                            fontSize: 12,
                            color: faculty.gradient.colors.first,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            children: faculty.staff.asMap().entries.map((entry) {
              final index = entry.key;
              final person = entry.value; // Artık PersonData nesnesi

              return AnimatedContainer(
                duration: Duration(milliseconds: 200 + (index * 50)),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        (person.name.contains('Dekan') ||
                            person.name.contains('Müdür'))
                        ? faculty.gradient.colors.first.withOpacity(0.1)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          (person.name.contains('Dekan') ||
                              person.name.contains('Müdür'))
                          ? faculty.gradient.colors.first.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: faculty.gradient.colors.first.withOpacity(
                                0.2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              (person.name.contains('Dekan') ||
                                      person.name.contains('Müdür'))
                                  ? Icons.star
                                  : Icons.person_outline,
                              color: faculty.gradient.colors.first,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              person.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    (person.name.contains('Dekan') ||
                                        person.name.contains('Müdür'))
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: const Color(0xFF2C3E50),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (person.about != null && person.about!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          person.about!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      if (person.cvUrl != null && person.cvUrl!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _launchURL(person.cvUrl!),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: faculty.gradient.colors.first.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: faculty.gradient.colors.first
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.description,
                                  size: 16,
                                  color: faculty.gradient.colors.first,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'CV / Özgeçmiş',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: faculty.gradient.colors.first,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// Yeni PersonData sınıfı
class PersonData {
  final String name;
  final String? about; // Hakkında bilgisi, opsiyonel
  final String? cvUrl; // CV linki, opsiyonel

  PersonData({required this.name, this.about, this.cvUrl});
}

// FacultyData sınıfı PersonData listesini içerecek şekilde güncellendi
class FacultyData {
  final String name;
  final IconData icon;
  final LinearGradient gradient;
  final List<PersonData> staff; // PersonData listesi oldu
  final String webUrl; // Fakültenin kendi web sayfası linki

  FacultyData(this.name, this.icon, this.gradient, this.staff, this.webUrl);
}
