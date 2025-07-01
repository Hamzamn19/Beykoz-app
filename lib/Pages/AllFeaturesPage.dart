import 'package:flutter/material.dart';
import 'package:beykoz/Pages/HomePage.dart'; // WebViewPage'inizin doğru yolda olduğundan emin olun
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AllFeaturesSheet extends StatefulWidget {
  const AllFeaturesSheet({super.key});

  @override
  State<AllFeaturesSheet> createState() => _AllFeaturesSheetState();
}

class _AllFeaturesSheetState extends State<AllFeaturesSheet> {
  // BÖLÜM DURUMLARI
  bool _isBelgelerExpanded = false;
  bool _isDersExpanded = false;
  bool _isDigerExpanded = false;

  // Sayfanın tam ekran olup olmadığını takip eden durum değişkeni
  bool _isFullyExpanded = false;

  // VERİ LİSTELERİ
  final List<Map<String, dynamic>> dersIslemleriFeatures = [
    {
      'label': 'Transkript',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/transkript',
      'icon': Icons.assignment_turned_in,
    },
    {
      'label': 'Karne',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/ogrkarne',
      'icon': Icons.grade,
    },
    {
      'label': 'Ders Programı',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/ogrdersprogrami',
      'icon': Icons.calendar_today,
    },
    {
      'label': 'Hazırlık Karne',
      'url': 'https://ois.beykoz.edu.tr/hazirlik/hazirliksinav/ogrpreptranskript',
      'icon': Icons.school,
    },
    {
      'label': 'Ders Onay Belgesi',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/dersdanismanonay',
      'icon': Icons.verified_user,
    },
    {
      'label': 'Kesin Kayıt Belgesi',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/kesinkayitbelgesi',
      'icon': Icons.how_to_reg,
    },
    {
      'label': 'Online Belge Talep',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/belgetalep/duzenle2',
      'icon': Icons.description,
    },
    {
      'label': 'Sınav Programı',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/sinavprogrami',
      'icon': Icons.schedule,
    },
  ];

  final List<Map<String, dynamic>> belgelerFeatures = [
    {
      'label': 'Ders Seçimi',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/derssecim/derssecimv2',
      'icon': Icons.rule,
    },
    {
      'label': 'Notlarım',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/ders/notlistesi',
      'icon': Icons.grading,
    },
    {
      'label': 'Devamsızlık',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/ders/devamsizlik',
      'icon': Icons.person_off,
    },
    {
      'label': 'Müfredat',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/ders/mufredat',
      'icon': Icons.list_alt,
    },
  ];

  final List<Map<String, dynamic>> digerIslemlerFeatures = [
    {
      'label': 'Akademik Takvim',
      'url': 'https://www.beykoz.edu.tr/akademik-takvim/',
      'icon': Icons.date_range,
    },
    {
      'label': 'Yemekhane Menüsü',
      'url':
      'https://www.beykoz.edu.tr/idari-birimler/destek-hizmetleri-daire-baskanligi/yemekhane-hizmetleri/',
      'icon': Icons.fastfood,
    },
    {
      'label': 'Servis Saatleri',
      'url': 'https://www.beykoz.edu.tr/ulasim/',
      'icon': Icons.directions_bus,
    },
    {
      'label': 'Kütüphane',
      'url': 'https://kutuphane.beykoz.edu.tr/',
      'icon': Icons.local_library,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        // EŞİK 1: Sayfa tam ekran oldu mu?
        if (notification.extent >= 0.99 && !_isFullyExpanded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isFullyExpanded = true;
                _isBelgelerExpanded = true;
                _isDersExpanded = true;
                _isDigerExpanded = true;
                // DEĞİŞİKLİK: Key'leri yeniden atayan satırlar kaldırıldı.
                // Animasyonun yeniden tetiklenmesini engellemek için bu adımı atıyoruz.
              });
            }
          });
        }
        // EŞİK 2: Sayfa tam ekrandan indi mi?
        else if (notification.extent < 0.61 && _isFullyExpanded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isFullyExpanded = false;
                _isBelgelerExpanded = false;
                _isDersExpanded = false;
                _isDigerExpanded = false;
                // DEĞİŞİKLİK: Key'leri yeniden atayan satırlar buradan da kaldırıldı.
              });
            }
          });
        }

        // Bu kısım sayfa yarıdan aşağı indiğinde geri kapanmasını sağlar
        if (notification.extent < 0.55) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        }
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.50,
        maxChildSize: 1.0,
        expand: true,
        snap: true,
        snapSizes: const [0.6, 1.0],
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF802629).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    child: Text(
                      'TÜMÜ',
                      style: TextStyle(
                        color: Color(0xFF802629),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildFeatureSection(
                  title: 'Ders İşlemleri',
                  features: dersIslemleriFeatures,
                  isExpanded: _isDersExpanded,
                  onToggle: () {
                    setState(() {
                      _isDersExpanded = !_isDersExpanded;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildFeatureSection(
                  title: 'Belgeler',
                  features: belgelerFeatures,
                  isExpanded: _isBelgelerExpanded,
                  onToggle: () {
                    setState(() {
                      _isBelgelerExpanded = !_isBelgelerExpanded;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildFeatureSection(
                  title: 'Diğer İşlemler',
                  features: digerIslemlerFeatures,
                  isExpanded: _isDigerExpanded,
                  onToggle: () {
                    setState(() {
                      _isDigerExpanded = !_isDigerExpanded;
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureSection({
    required String title,
    required List<Map<String, dynamic>> features,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    // DEĞİŞİKLİK: animationKey parametresi artık gerekli değil.
    final bool canExpand = features.length > 4;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFECECEC),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.only(top: 16.0, left: 16.0, bottom: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF802629),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AnimationLimiter(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: isExpanded
                      ? features.length
                      : (canExpand ? 4 : features.length),
                  itemBuilder: (context, index) {
                    final item = features[index];

                    // AÇIKLAMA: Bu, `GridView` içindeki her bir öğenin temel widget'ıdır.
                    // Animasyonlu veya animasyonsuz olarak sarmalanacaktır.
                    Widget featureItem = InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              url: item['url']!,
                              username: null,
                              password: null,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 56.75,
                            height: 56.75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF802629),
                                  Color(0xFFB2453C),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              item['icon'],
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Flexible(
                            child: Text(
                              item['label']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF802629),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    );

                    // DEĞİŞİKLİK: Animasyonun uygulanıp uygulanmayacağını belirleyen koşul.
                    // Koşul: Sayfa tam ekran DEĞİLSE veya öğenin indeksi 4'ten BÜYÜK veya EŞİTSE animasyon uygula.
                    final bool shouldAnimate = !_isFullyExpanded || index >= 4;

                    if (shouldAnimate) {
                      // AÇIKLAMA: Koşul sağlandığında, öğeyi animasyon widget'ları ile sarmala.
                      // Bu, ilk açılışta ve sayfa genişlediğinde yeni gelen öğeler için çalışır.
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 4,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: featureItem,
                          ),
                        ),
                      );
                    } else {
                      // AÇIKLAMA: Sayfa tam ekran olduğunda ilk 4 öğe için bu blok çalışır.
                      // Öğeyi animasyonsuz, doğrudan döndürür.
                      return featureItem;
                    }
                  },
                ),
              ),
              if (canExpand)
                Center(
                  child: IconButton(
                    icon: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFF802629),
                    ),
                    onPressed: onToggle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
