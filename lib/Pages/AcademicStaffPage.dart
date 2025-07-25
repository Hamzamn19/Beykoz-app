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
          iconTheme: const IconThemeData(color: Colors.white),
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
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 30,
                  ),
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
                              : Colors.grey,
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
                    : Colors.grey,
              ),
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
            name: 'Prof. Dr. İlker KIYMETLİ ŞEN',
            about: 'Dekan V.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1014.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Aslıhan BEKAROĞLU ÖZATAR',
            about: 'Dekan Yardımcısı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/37.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Aysun VARAN',
            about: 'Dekan Yardımcısı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/14.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Ezgi UZEL AYDINOCAK',
            about: 'Lojistik Yönetimi (İngilizce) Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/42.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Mehmet YEŞİLYAPRAK',
            about: 'İşletme (Türkçe) Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/590.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Neslihan BALCI VAROL',
            about:
                'Uluslararası Ticaret ve Finansman (İngilizce) Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/13.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Özgür Burçak GÜRSOY YENİLMEZ',
            about: 'İşletme (İngilizce) Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/41.pdf',
          ),
          PersonData(name: 'Elif BURAK', about: 'Fakülte Sekreteri', cvUrl: ''),
          PersonData(
            name: 'Prof. Dr. Osman Zihni ZAİM',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/835.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Baki AKSU',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/12.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. M. Mustafa ERDOĞDU',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/707.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. K. Evren BOLGÜN',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/701.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Tolga YAZICI',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/780.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Ümit Deniz İLHAN',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/703.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Sezin AÇIK TAŞAR',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/705.pdf',
          ),

          PersonData(
            name: 'Dr. Öğr. Üyesi Emre ERGÜVEN',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/52.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Cihan TINAZTEPE ÇAĞLAR',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/833.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Hüsniye FIRAT',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/601.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Nesli ÇANKIRI KIRAN',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/27.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Esra Nur GÖKHAN',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/203.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Hande SAĞLAM',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/963.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Güler SAĞLAM',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/251.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Ezgi ÇOLAK',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/147.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. İlkay AKBAŞ',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/712.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Ergün Pirsefa YILDIRIM',
            about: 'İşletme ve Yönetim Bilimleri Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/882.pdf',
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
            name: 'Prof. Dr. Mansur BEYAZYÜREK',
            about: 'Dekan',
            cvUrl: 'https://www.beykoz.edu.tr/personel/168.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Hatice Gülsen ERDEN',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/713.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Zeynep HAMAMCI',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/714.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Burak KÜNTAY',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/697.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Ahmet Kasım HAN',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/771.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Ragıp Kutay KARACA',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/949.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Ali ÇİVRİL',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1025.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Pınar SAYAN',
            about:
                'Dekan Yardımcısı/ Siyaset Bilimi ve Uluslararası İlişkiler Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/132.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Pınar KURT COMBİL',
            about: 'Psikoloji Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/994.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Hakkı BAŞGÜNEY',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/351.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Seval ÜNLÜ GÖK',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/131.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Özgül AKINCI',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/653.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Eda YILMAZER',
            about: 'Dekan Yardımcısı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/763.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Özge SARIYER YILMAZ',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/944.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Müge AKKOYUN',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/952.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Pelin HAZER',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1020.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Emir AYDOĞAN',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/773.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Nihan PASAFÇIOĞLU',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/884.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Merve TAŞDELEN',
            about: 'Sosyal Bilimler Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/956.pdf',
          ),
          PersonData(name: 'Elif SEZER', about: 'Fakülte Sekreteri', cvUrl: ''),
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
            name: 'Dr. Öğr. Üyesi Meltem KAYHAN',
            about: 'Endüstri Mühendisliği Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/706.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Gizem TEMELCAN ERGENECOŞAR',
            about: 'Dekan Yardımcısı/ Yazılım Mühendisliği Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/371.pdf',
          ),

          PersonData(
            name: 'Prof. Dr. Selahattin KURU',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/138.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Abdurazzag Alı A ABURAS',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/874.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Ercan SOLAK',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/696.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Erhan BÜTÜN',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/591.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Nevzat Evrim ÖNAL',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/38.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi İlhan GARİP',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/943.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Özlem GEYLANİ',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/953.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Engin SANSARCI',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/880.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Özlem Feyza ERKAN',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/142.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Dürdane YILMAZ',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/885.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Rahime Hande CANBİLEN OMACAN',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1018.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Serra ERSOY ŞAHİN',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1017.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Elif Bilge ŞAHİN',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/599.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Ümran AYDIN',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/826.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Alp Eren KIYAK',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1012.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Roza Mercan ESKİN',
            about: 'Mühendislik ve Mimarlık Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1023.pdf',
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
            name: 'Prof. Dr. Bengisu BAYRAK SHAHMIRI',
            about: 'Dekan',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/381.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Çeyiz MAKAL FAIRCLOUGH',
            about: 'Dekan Yardımcısı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/554.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Banu Burçin ÖZTUNÇ',
            about: 'Dekan Yardımcısı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/631.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Pınar Seden MERAL',
            about: 'İletişim ve Tasarımı Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/59.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Merva KELEKÇİ OLGUN',
            about: 'Grafik Tasarım Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/92.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Bihter Erdem OKUMUŞ',
            about: 'İç Mimarlık ve Çevre Tasarımı Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/158.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Ahu SAMAV UĞURSOY',
            about: 'Halkla İlişkiler ve Reklamcılık Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/161.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Zeynep KUNT',
            about: 'Radyo, Televizyon ve Sinema Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/246.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Serap NAZIR',
            about: 'Gastronomi ve Mutfak Sanatları Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/804.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Orkun YÖNTEM',
            about: 'Dijital Oyun Tasarımı Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/680.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Gökhan Aydın',
            about: 'Çizgi Film ve Animasyon Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/951.pdf',
          ),
          PersonData(name: 'Nida Maraş', about: 'Fakülte Sekreteri', cvUrl: ''),
          PersonData(
            name: 'Prof. Dr. Armağan GÖKÇEARSLAN',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1024.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Emre Ahmet SEÇMEN',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/374.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Füsun Deniz ÖZDEN',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/154.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Gökçe SÖZEN',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/244.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Anıl SAYAN',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/588.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Selcen Nur ERİKÇİ ÇELİK',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/679.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi İrem AYAN DANACILAR',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/162.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Serap BOZKURT',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/89.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Ali Aşur DELEN',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/93.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Nur Ertürk',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/955.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Selda KARAHAN',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1015.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Beste Nur İSKENDER AYDIN',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1019.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Çise GÖKÇE',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/300.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Münür İPEK',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/355.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Setenay GÜLTEKİN',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/483.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Aylin Berna ZAMANDAR BAŞOĞLU',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/694.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Ayşenur ERTEN',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/828.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Betül TAŞ',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/827.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Erdinç KAYGUSUZ',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/711.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Feyza ASLAN',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/583.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Muhammet YILDIZ',
            about: 'Sanat ve Tasarım Fakültesi akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1011.pdf',
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
            name: 'Dr. Öğr. Üyesi Burak ÇAKALOZ',
            about: 'Deniz ve Liman İşletmeciliği Program Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/24.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Burak Nedim AKTAŞ',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/675.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Nesli ÇANKIRI KIRAN',
            about: 'Müdür',
            cvUrl: 'https://www.beykoz.edu.tr/personel/27.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Cansu ŞAHİN KÖLEMEN',
            about: 'Müdür Yardımcısı / Bilgisayar Teknolojileri Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/225.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Duygu YAMAN',
            about: 'Lojistik Program Başkanı / Hava Lojistiği Program Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/356.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Mehmet Bilgin SÜME',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/942.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Önder YERAL',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/15.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Buket DÖNMEZ',
            about: 'Bilgisayar Programcılığı Program Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/878.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Özhan GÖRÇÜN',
            about: 'Raylı Sistemler Program Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/783.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Ebru TEPEÇAM',
            about: 'Müdür Yardımcısı / Ulaştırma Hizmetleri Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/580.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Mediha BANBAL',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/29.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Oğuzhan ÇAÇAMER',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/28.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Nigar BABAYEVA',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/709.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Fatih Zahid GENÇ',
            about: 'Bilişim Güvenliği Teknolojisi Program Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/879.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Pervin Ahu ÇERÇİ',
            about: 'Dış Ticaret Bölüm Başkanı / Dış Ticaret Program Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/222.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Hande İpek ARSLAN',
            about:
                'Sivil Havacılık Kabin Hizmetleri (İngilizce) Program Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/357.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Nebi ARAZ',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/362.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Arzu ÖZÇELİK',
            about: 'Sivil Havacılık Kabin Hizmetleri (Türkçe) Program Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/414.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Elif İLHAN',
            about: 'Sivil Hava Ulaştırma İşletmeciliği Program Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/415.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Gürkan ŞASİ',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/413.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Cem KAZAN',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/582.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Zehra KAYA',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/676.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Başak KURU',
            about:
                'Yönetim ve Organizasyon Bölüm Başkanı/ Lojistik Programları Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/831.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Saliha UYAK ÇELİK',
            about:
                'Pazarlama ve Reklamcılık Bölüm Başkanı / E-Ticaret ve Pazarlama Program Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/838.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Semanur YALÇIN',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/941.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Utkan ÖNDER',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/683.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Abdullah ALAGÖZ',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/888.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Alper ŞEN',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1013.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Fatih BİNGÜL',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/940.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Yusuf Gökhan YILDIZ',
            about: 'Beykoz Lojistik Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1016.pdf',
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
            name: 'Öğr. Gör. Pınar PAMUK',
            about: 'Yabancı Diller Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/110.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Mediha BANBAL',
            about: 'Yabancı Diller Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/29.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Aisulu DOSZHANOVA',
            about: 'Yabancı Diller Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/314.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Muhammet GÜNDÜZ',
            about: 'Yabancı Diller Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/30.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Zeynep DAĞ',
            about: 'Yabancı Diller Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/189.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Viktoriya SAYGIN',
            about: 'Yabancı Diller Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/708.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Reza SAHMANIASL',
            about: 'Yabancı Diller Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/779.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Farideh MORADI GOLOSHEJERDI',
            about: 'Yabancı Diller Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/954.pdf',
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
            name: 'Öğr. Gör. Kadir ŞEKER',
            about: 'Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/97.pdf',
          ),
          PersonData(
            name: 'Prof. Dr. Kaan MERİÇ',
            about: 'Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/384.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Amil HÜSEYNOV',
            about: 'Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/596.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Zehra KAYA',
            about:
                'Paz. ve Rek. Bölümü Başkan V.-Sos. Hizm. ve Dan. Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/676.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Nebi ARAZ',
            about: 'Tıbbi Hizmetler ve Teknikler Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/362.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Özge DEMİR',
            about: 'Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1021.pdf',
          ),
          PersonData(
            name: 'Öğr. Gör. Yasemin GÜNTER',
            about: 'Meslek Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/1022.pdf',
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
            name: 'Prof. Dr. Erhan BÜTÜN',
            about: 'Müdür',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/591.pdf',
          ),
          PersonData(
            name: 'Doç. Dr. Nigar Çağla MUTLUCAN',
            about: 'Müdür Yardımcısı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/63.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Behiye BEĞENDİK',
            about: 'Havacılık Yönetimi Bölüm Başkanı',
            cvUrl: 'https://www.beykoz.edu.tr/personel/64.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Caner ŞENTÜRK',
            about: 'Sivil Havacılık Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/772.pdf',
          ),
          PersonData(
            name: 'Dr. Öğr. Üyesi Melike Mehveş PAMUK',
            about: 'Sivil Havacılık Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/uploads/staffs/21.pdf',
          ),
          PersonData(
            name: 'Araş. Gör. Serhan KARADENİZ',
            about: 'Sivil Havacılık Yüksekokulu akademik kadrosu.',
            cvUrl: 'https://www.beykoz.edu.tr/personel/365.pdf',
          ),
          PersonData(name: 'Elif BURAK', about: 'Fakülte Sekreteri', cvUrl: ''),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                splashColor:
                    (themeService.isDarkMode
                            ? ThemeService.darkPrimaryColor
                            : primaryColor)
                        .withOpacity(0.1),
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
                            : Colors.grey.shade600,
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
                          color:
                              (themeService.isDarkMode
                                      ? ThemeService.darkPrimaryColor
                                      : primaryColor)
                                  .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                (themeService.isDarkMode
                                        ? ThemeService.darkPrimaryColor
                                        : primaryColor)
                                    .withOpacity(0.3),
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
                                  : primaryColor,
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
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            (person.name.contains('Dekan') ||
                                person.name.contains('Müdür'))
                            ? (themeService.isDarkMode
                                      ? ThemeService.darkPrimaryColor
                                      : primaryColor)
                                  .withOpacity(0.1)
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
                                        : primaryColor)
                                    .withOpacity(0.3)
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
                                  color:
                                      (themeService.isDarkMode
                                              ? ThemeService.darkPrimaryColor
                                              : primaryColor)
                                          .withOpacity(0.2),
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
                          if (person.about != null &&
                              person.about!.isNotEmpty) ...[
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
                          if (person.cvUrl != null &&
                              person.cvUrl!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _launchURL(person.cvUrl!),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      (themeService.isDarkMode
                                              ? ThemeService.darkPrimaryColor
                                              : primaryColor)
                                          .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        (themeService.isDarkMode
                                                ? ThemeService.darkPrimaryColor
                                                : primaryColor)
                                            .withOpacity(0.3),
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
