import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:beykoz/Services/theme_service.dart';
import 'package:provider/provider.dart';

class AcademicStaffPage extends StatefulWidget {
  const AcademicStaffPage({super.key});

  @override
  State<AcademicStaffPage> createState() => _AcademicStaffPageState();
}

class _AcademicStaffPageState extends State<AcademicStaffPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  static const Color primaryColor = Color(0xFF802629);
  static const Color cardColor = Color(0xFFECECEC);

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
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.isDarkMode 
              ? ThemeService.darkBackgroundColor 
              : Colors.white,
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
      },
    );
  }

  Widget _buildSliverAppBar() {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Akademik Kadro',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3.0,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF802629), Color(0xFFB2453C)],
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
          backgroundColor: themeService.isDarkMode 
              ? ThemeService.darkPrimaryColor 
              : primaryColor,
        );
      },
    );
  }

  Widget _buildHeaderSection() {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF802629), Color(0xFFB2453C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.school, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fakülteler ve Akademik Birimler',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themeService.isDarkMode 
                              ? ThemeService.darkTextPrimaryColor 
                              : Color(0xFF802629),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fakülteler ve Yüksekokullar',
                        style: TextStyle(
                          fontSize: 14, 
                          color: themeService.isDarkMode 
                              ? ThemeService.darkTextSecondaryColor 
                              : Colors.grey
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsCard() {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeService.isDarkMode 
                ? ThemeService.darkCardColor 
                : cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
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
      },
    );
  }

  Widget _buildStatItem(String number, String label, IconData icon) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF802629), Color(0xFFB2453C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              number,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeService.isDarkMode 
                    ? ThemeService.darkTextPrimaryColor 
                    : Color(0xFF802629),
              ),
            ),
            Text(
              label, 
              style: TextStyle(
                fontSize: 12, 
                color: themeService.isDarkMode 
                    ? ThemeService.darkTextSecondaryColor 
                    : Colors.grey
              )
            ),
          ],
        );
      },
    );
  }

  Widget _buildFacultiesSection() {
    final faculties = [
      FacultyData(
        'İşletme ve Yönetim Bilimleri Fakültesi',
        Icons.business_center,
        const LinearGradient(colors: [Color(0xFF802629), Color(0xFFB2453C)]),
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
        const LinearGradient(colors: [Color(0xFF802629), Color(0xFFB2453C)]),
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
        const LinearGradient(colors: [Color(0xFF802629), Color(0xFFB2453C)]),
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
        const LinearGradient(colors: [Color(0xFF802629), Color(0xFFB2453C)]),
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
        const LinearGradient(colors: [Color(0xFF802629), Color(0xFFB2453C)]),
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
        const LinearGradient(colors: [Color(0xFF802629), Color(0xFFB2453C)]),
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
        const LinearGradient(colors: [Color(0xFF802629), Color(0xFFB2453C)]),
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
        const LinearGradient(colors: [Color(0xFF802629), Color(0xFFB2453C)]),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer<ThemeService>(
          builder: (context, themeService, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: themeService.isDarkMode 
                    ? ThemeService.darkPrimaryColor 
                    : primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'FAKÜLTELER',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        ...faculties.asMap().entries.map((entry) {
          final index = entry.key;
          final faculty = entry.value;

          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 16),
            child: _buildFacultyCard(faculty),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFacultyCard(FacultyData faculty) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
              color: themeService.isDarkMode 
                  ? ThemeService.darkCardColor 
                  : cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: (themeService.isDarkMode 
                    ? ThemeService.darkPrimaryColor 
                    : primaryColor).withOpacity(0.1),
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                childrenPadding: const EdgeInsets.only(bottom: 16),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: faculty.gradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(faculty.icon, color: Colors.white, size: 30),
                ),
                title: Text(
                  faculty.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeService.isDarkMode 
                        ? ThemeService.darkTextPrimaryColor 
                        : Color(0xFF802629),
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${faculty.staff.length} akademisyen',
                      style: TextStyle(
                        fontSize: 12, 
                        color: themeService.isDarkMode 
                            ? ThemeService.darkTextSecondaryColor 
                            : Colors.grey.shade600
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _launchURL(faculty.webUrl),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (themeService.isDarkMode 
                              ? ThemeService.darkPrimaryColor 
                              : primaryColor).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (themeService.isDarkMode 
                                ? ThemeService.darkPrimaryColor 
                                : primaryColor).withOpacity(0.3)
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.link, 
                              size: 14, 
                              color: themeService.isDarkMode 
                                  ? ThemeService.darkPrimaryColor 
                                  : primaryColor
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Fakülte Sayfası',
                              style: TextStyle(
                                fontSize: 12,
                                color: themeService.isDarkMode 
                                    ? ThemeService.darkPrimaryColor 
                                    : primaryColor,
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
                  final person = entry.value;

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200 + (index * 50)),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            (person.name.contains('Dekan') ||
                                person.name.contains('Müdür'))
                            ? (themeService.isDarkMode 
                                ? ThemeService.darkPrimaryColor 
                                : primaryColor).withOpacity(0.1)
                            : (themeService.isDarkMode 
                                ? ThemeService.darkCardColor 
                                : cardColor),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              (person.name.contains('Dekan') ||
                                  person.name.contains('Müdür'))
                              ? (themeService.isDarkMode 
                                  ? ThemeService.darkPrimaryColor 
                                  : primaryColor).withOpacity(0.3)
                              : Colors.transparent,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: (themeService.isDarkMode 
                                      ? ThemeService.darkPrimaryColor 
                                      : primaryColor).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  (person.name.contains('Dekan') ||
                                          person.name.contains('Müdür'))
                                      ? Icons.star
                                      : Icons.person_outline,
                                  color: themeService.isDarkMode 
                                      ? ThemeService.darkPrimaryColor 
                                      : primaryColor,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  person.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        (person.name.contains('Dekan') ||
                                            person.name.contains('Müdür'))
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: themeService.isDarkMode 
                                        ? ThemeService.darkTextPrimaryColor 
                                        : Color(0xFF802629),
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
                                fontSize: 12,
                                color: themeService.isDarkMode 
                                    ? ThemeService.darkTextPrimaryColor 
                                    : Colors.grey.shade700,
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
                                  color: (themeService.isDarkMode 
                                      ? ThemeService.darkPrimaryColor 
                                      : primaryColor).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: (themeService.isDarkMode 
                                        ? ThemeService.darkPrimaryColor 
                                        : primaryColor).withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.description,
                                      size: 14,
                                      color: themeService.isDarkMode 
                                          ? ThemeService.darkPrimaryColor 
                                          : primaryColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'CV / Özgeçmiş',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: themeService.isDarkMode 
                                            ? ThemeService.darkPrimaryColor 
                                            : primaryColor,
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
      },
    );
  }
}

class PersonData {
  final String name;
  final String? about;
  final String? cvUrl;

  PersonData({required this.name, this.about, this.cvUrl});
}

class FacultyData {
  final String name;
  final IconData icon;
  final LinearGradient gradient;
  final List<PersonData> staff;
  final String webUrl;

  FacultyData(this.name, this.icon, this.gradient, this.staff, this.webUrl);
}
