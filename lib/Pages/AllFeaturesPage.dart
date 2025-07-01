import 'package:flutter/material.dart';
// HomePage'e ve WebViewPage'e erişim için import edildi.
import 'package:beykoz/Pages/HomePage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AllFeaturesSheet extends StatelessWidget {
  const AllFeaturesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Taslak olarak eklenecek tüm özelliklerin listesi
    // HomePage'deki yapıya benzer şekilde 'label', 'icon' ve 'url' içerir.
    final List<Map<String, dynamic>> allFeatures = [
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
      {
        'label': 'Akademik Takvim',
        'url': 'https://www.beykoz.edu.tr/akademik-takvim/',
        'icon': Icons.date_range,
      },
      {
        'label': 'Yemekhane Menüsü',
        'url': 'https://www.beykoz.edu.tr/idari-birimler/destek-hizmetleri-daire-baskanligi/yemekhane-hizmetleri/',
        'icon': Icons.fastfood,
      },
      {
        'label': 'Servis Saatleri',
        'url': 'https://www.beykoz.edu.tr/ulasim/',
        'icon': Icons.directions_bus,
      },
      {
        'label': 'Servis Saatleri',
        'url': 'https://www.beykoz.edu.tr/ulasim/',
        'icon': Icons.directions_bus,
      },
      {
        'label': 'Servis Saatleri',
        'url': 'https://www.beykoz.edu.tr/ulasim/',
        'icon': Icons.directions_bus,
      },
      {
        'label': 'Servis Saatleri',
        'url': 'https://www.beykoz.edu.tr/ulasim/',
        'icon': Icons.directions_bus,
      },
      {
        'label': 'Servis Saatleri',
        'url': 'https://www.beykoz.edu.tr/ulasim/',
        'icon': Icons.directions_bus,
      },
      {
        'label': 'Servis Saatleri',
        'url': 'https://www.beykoz.edu.tr/ulasim/',
        'icon': Icons.directions_bus,
      },
      {
        'label': 'Servis Saatleri',
        'url': 'https://www.beykoz.edu.tr/ulasim/',
        'icon': Icons.directions_bus,
      },
      // Gelecekte eklenecek diğer özellikler buraya gelebilir.
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.50,
      maxChildSize: 1.0,
      expand: true,
      snap: true,
      snapSizes: const [0.6, 1.0],
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white, // Burası beyaz kalacak (üst kısım için)
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // --- Sürükleme Çubuğu ---
              Container(
                width: 80,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF802629).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // --- Sayfa Başlığı ---
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

              // --- Izgara (Grid) İçeriği ---
              Expanded(
                child: Padding( // YENİ: Boşluk eklemek için Padding widget'ı
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 17.0), // Sağdan ve soldan 16 piksel boşluk
                child: Container( // YENİ: GridView'i saran Container
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECECEC), // Rengi buraya taşıdık.
                    borderRadius: BorderRadius.circular(20.0), // Tüm köşeleri 20 piksel yuvarlattık.
                  ),
                  child: AnimationLimiter(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: allFeatures.length,
                      itemBuilder: (context, index) {
                        final item = allFeatures[index];

                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 4,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: InkWell(
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
                                Flexible( // <--- EKLENEN WIDGET
                                  child:
                                  Text(
                                      item['label']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF802629),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        height: 1.1,
                                      ),
                                    ),
                                ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ), //container
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}