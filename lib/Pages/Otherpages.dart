import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Transportation.dart'; // Make sure this file exists and is correct
import 'AcademicStaffPage.dart'; // Import the new AcademicStaffPage
import 'package:beykoz/Services/theme_service.dart';
import 'package:provider/provider.dart';

class OtherPages extends StatelessWidget {
  const OtherPages({super.key});

  // Function to launch URL
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      throw Exception('Bağlantı açılamadı: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        // List of items using the helper class
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
          // --- Transportation and Communication Item ---
          _ActionItem(
            icon: Icons.directions_bus,
            color: const Color(0xFF0A285F), // Same as the old button color
            label: 'Ulaşım ve İletişim',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransportationPage()),
              );
            },
          ),
          // --- New Academic Staff Item ---
          _ActionItem(
            icon: Icons.school, // You can choose an appropriate icon
            color: Colors.brown, // Choose a suitable color
            label: 'Akademik Kadro',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AcademicStaffPage()),
              );
            },
          ),
        ];

        return Scaffold(
          backgroundColor: themeService.isDarkMode 
              ? ThemeService.darkBackgroundColor 
              : ThemeService.lightBackgroundColor,
          appBar: AppBar(
            title: const Text(
              'Diğer Sayfalar',
            ), // Title adjusted to better reflect content
            backgroundColor: themeService.isDarkMode 
                ? ThemeService.darkPrimaryColor 
                : const Color(0xFF802629),
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
            child: Column(
              children: [
                Text(
                  'Önemli Bağlantılar ve Servisler', // Title adjusted
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold,
                    color: themeService.isDarkMode 
                        ? ThemeService.darkTextPrimaryColor 
                        : ThemeService.lightTextPrimaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                // The grid is now the only expandable element and fills the space
                Expanded(
                  child: GridView.builder(
                    // Using GridView.builder for better performance if the list is large
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio:
                          1.1, // You can adjust this ratio to change item height
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return InkWell(
                        // Call the item's onTap function when pressed
                        onTap: item.onTap,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeService.isDarkMode 
                                ? ThemeService.darkCardColor 
                                : Colors.white,
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
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: themeService.isDarkMode 
                                      ? ThemeService.darkTextPrimaryColor 
                                      : ThemeService.lightTextPrimaryColor,
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
      },
    );
  }
}

// --- Helper Class ---
// This class describes any executable item in the grid
// It contains an icon, color, label, and a function (onTap) to execute when pressed
class _ActionItem {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback
  onTap; // Function that returns no value and takes no parameters

  const _ActionItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });
}
