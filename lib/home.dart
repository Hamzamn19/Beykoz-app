import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'attendance.dart';

// Ana Ekran ve Bottom Navigation Bar mantığını içeren ana widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Bottom Navigation Bar için sayfaların listesi
  static final List<Widget> _pages = <Widget>[
    const DesignedHomePage(), // ANA SAYFA TASARIMIMIZ
    WebViewPage(url: 'https://ois.beykoz.edu.tr/'),
    WebViewPage(url: 'https://online.beykoz.edu.tr'),
    AttendanceScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- DEĞİŞİKLİK BURADA ---
    // Scaffold widget'ından `appBar` parametresi tamamen kaldırıldı.
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web),
            label: 'OIS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Online',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Yoklama',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: const Color(0xFF802629), // Ana renk temamızla uyumlu
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- YENİ ANA SAYFA TASARIMI WIDGET'I ---
// Görseldeki tasarımı birebir uyguladığımız kısım
class DesignedHomePage extends StatelessWidget {
  const DesignedHomePage({super.key});

  // Tasarımda kullanılan ana renk
  static const Color primaryColor = Color(0xFF802629);
  static const Color cardColor = Color(0xFFECECEC);

  @override
  Widget build(BuildContext context) {
    // Sayfanın en üstten başlaması ve durum çubuğu (saat, pil vs.) ile
    // çakışmaması için SafeArea widget'ı ekliyoruz.
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- ÜST BUTONLAR ("B") ---
              _buildTopButtons(),
              const SizedBox(height: 24),

              // --- SIK KULLANILANLAR BÖLÜMÜ ---
              _buildSectionTitle('SIK KULLANILANLAR'),
              const SizedBox(height: 12),
              _buildFrequentlyUsedGrid(),
              const SizedBox(height: 16),

              // --- ORTADAKİ BUTON ("B") ---
              ElevatedButton(
                onPressed: () {
                  // Bu butona tıklandığında yapılacak işlem (şimdilik boş)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'B',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),

              // --- DUYURULAR BÖLÜMÜ ---
              _buildSectionTitle('DUYURULAR'),
              const SizedBox(height: 12),
              _buildAnnouncementCard(), // İlk duyuru kartı
              const SizedBox(height: 16),
              _buildAnnouncementCard(), // İkinci duyuru kartı
            ],
          ),
        ),
      ),
    );
  }

  // --- YARDIMCI METOTLAR (WIDGET OLUŞTURUCULAR) ---

// home.dart dosyasından

// home.dart dosyasından

  Widget _buildTopButtons() {
    return Row(
      children: [
        // --- DİKDÖRTGEN BUTON YERİNE TIKLANABİLİR GÖRSEL ---
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              // Görsele tıklandığında yapılacak işlemi buraya yazın.
              // Örneğin bir mesaj yazdırabilir veya yeni bir sayfaya gidebilirsiniz.
              print('Görsel butona tıklandı!');
            },
            // --- DEĞİŞİKLİK BURADA BAŞLIYOR ---
            // Image widget'ını, sola hizalamak için Align widget'ı ile sardık.
            child: Align(
              alignment: Alignment.centerLeft, // Bu satır, içindeki öğeyi sola yaslar.
              child: Image.asset(
                'assets/images/logo.png', // Görselinizin yolu
                fit: BoxFit.contain,
                height: 48,
              ),
            ),
            // --- DEĞİŞİKLİK BURADA BİTİYOR ---
          ),
        ),
        // --- Bitiş ---

        const SizedBox(width: 16),

        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularButton(
                Icons.search,       // İkon
                const Color(0xFFECECEC),   // Arka Plan Rengi
                const Color(0xFF802629),   // İkon Rengi
              ),
              _buildCircularButton(
                Icons.notifications,    // İkon
                const Color(0xFF802629),  // Arka Plan Rengi
                Colors.white,           // İkon Rengi
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircularButton(IconData icon, Color backgroundColor, Color iconColor) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        // --- DEĞİŞİKLİK BURADA ---
        // Arka plan rengi artık sabit değil, parametreden geliyor.
        backgroundColor: backgroundColor,
      ),
      child: Icon(
        icon,
        // --- DEĞİŞİKLİK BURADA ---
        // İkon rengi de artık sabit değil, parametreden geliyor.
        color: iconColor,
        size: 30,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildFrequentlyUsedGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'L',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnnouncementCard() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'L',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


// --- WEBVIEW SAYFASI ---
class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({required this.url, super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}


class _WebViewPageState extends State<WebViewPage> with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sayfa yüklenirken hata oluştu: ${error.description}')),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF802629)),
            ),
          ),
      ],
    );
  }
}
