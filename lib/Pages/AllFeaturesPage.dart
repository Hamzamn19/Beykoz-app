import 'package:flutter/material.dart';
import 'package:beykoz/Pages/HomePage.dart'; // WebViewPage'inizin doğru yolda olduğundan emin olun
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// DEĞİŞİKLİK: Veri sınıfımızı import ediyoruz. Bu zaten dosyanızda mevcuttu.
import 'package:beykoz/data/features_data.dart';
import 'package:beykoz/Services/theme_service.dart';
import 'package:provider/provider.dart';

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

  // DEĞİŞİKLİK: Yerel veri listeleri kaldırıldı.
  // Artık 'dersIslemleriFeatures', 'belgelerFeatures', ve 'digerIslemlerFeatures'
  // listeleri bu dosyada tanımlı değil. Onları doğrudan FeaturesData sınıfından kullanacağız.

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
          return Consumer<ThemeService>(
            builder: (context, themeService, child) {
              return Container(
                decoration: BoxDecoration(
                  color: themeService.isDarkMode 
                      ? ThemeService.darkCardColor 
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
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
                        width: 85,
                        height: 5,
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECECEC), // Kaydırma çubuğunun rengi
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebViewPage(
                                url: 'https://www.beykoz.edu.tr/', // Hedef URL
                              ),
                            ),
                          );
                        },
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 46,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildFeatureSection(
                      title: 'Ders İşlemleri',
                      // DEĞİŞİKLİK: Veriyi yerel liste yerine FeaturesData sınıfından alıyoruz.
                      features: FeaturesData.dersIslemleriFeatures,
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
                      // DEĞİŞİKLİK: Veriyi yerel liste yerine FeaturesData sınıfından alıyoruz.
                      features: FeaturesData.belgelerFeatures,
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
                      // DEĞİŞİKLİK: Veriyi yerel liste yerine FeaturesData sınıfından alıyoruz.
                      features: FeaturesData.digerIslemlerFeatures,
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
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        final bool canExpand = features.length > 4;

        return ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                color: themeService.isDarkMode 
                    ? ThemeService.darkSurfaceColor 
                    : const Color(0xFFECECEC),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, bottom: 8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: themeService.isDarkMode 
                            ? ThemeService.darkPrimaryColor 
                            : Color(0xFF802629),
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
                                  style: TextStyle(
                                    color: themeService.isDarkMode 
                                        ? ThemeService.darkTextPrimaryColor 
                                        : Color(0xFF802629),
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

                        final bool shouldAnimate = !_isFullyExpanded || index >= 4;

                        if (shouldAnimate) {
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
                          color: themeService.isDarkMode 
                              ? ThemeService.darkTextPrimaryColor 
                              : Color(0xFF802629),
                        ),
                        onPressed: onToggle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}