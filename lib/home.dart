import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Ana Ekran ve Bottom Navigation Bar mantığını içeren ana widget
class HomeScreen extends StatefulWidget {
  final String? username;
  final String? password;
  const HomeScreen({super.key, this.username, this.password});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const DesignedHomePage(),
      WebViewPage(
        url: 'https://ois.beykoz.edu.tr/',
        username: widget.username,
        password: widget.password,
      ),
      WebViewPage(
        url: 'https://online.beykoz.edu.tr',
        username: widget.username,
        password: widget.password,
      ),
    ];
  }

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
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.web), label: 'OIS'),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Online'),
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
              alignment:
              Alignment.centerLeft, // Bu satır, içindeki öğeyi sola yaslar.
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
                Icons.search, // İkon
                const Color(0xFFECECEC), // Arka Plan Rengi
                const Color(0xFF802629), // İkon Rengi
              ),
              _buildCircularButton(
                Icons.notifications, // İkon
                const Color(0xFF802629), // Arka Plan Rengi
                Colors.white, // İkon Rengi
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircularButton(
      IconData icon,
      Color backgroundColor,
      Color iconColor,
      ) {
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
    // Liste des éléments avec icônes
    final List<Map<String, dynamic>> frequentlyUsed = [
      {
        'label': 'Transcript',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/transkript',
        'icon': Icons.assignment_turned_in,
      },
      {
        'label': 'Report Card',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/ogrkarne',
        'icon': Icons.grade,
      },
      {
        'label': 'Course Program',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/ogrdersprogrami',
        'icon': Icons.calendar_today,
      },
      {
        'label': 'Prep Transcript',
        'url': 'https://ois.beykoz.edu.tr/hazirlik/hazirliksinav/ogrpreptranskript',
        'icon': Icons.school,
      },
      {
        'label': 'Approval Certificate',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/dersdanismanonay',
        'icon': Icons.verified_user,
      },
      {
        'label': 'Final Registration',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/kesinkayitbelgesi',
        'icon': Icons.how_to_reg,
      },
      {
        'label': 'Document Request',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belgetalep/duzenle2',
        'icon': Icons.description,
      },
      {
        'label': 'Exam Schedule',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/sinavprogrami',
        'icon': Icons.schedule,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8, // أقل من 1 ليظهر النص أسفل الأيقونة
      ),
      itemCount: frequentlyUsed.length,
      itemBuilder: (context, index) {
        final item = frequentlyUsed[index];
        return InkWell(
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
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
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
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  item['icon'],
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['label']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF802629),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
  final String? username;
  final String? password;

  const WebViewPage({
    required this.url,
    this.username,
    this.password,
    super.key,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });
            // Disable auto-login for OIS pages
            if (widget.username != null &&
                widget.password != null &&
                !(widget.url.startsWith('https://ois.beykoz.edu.tr'))) {
              // Remove everything after @ (and @ itself) from username
              String username = widget.username!;
              final atIndex = username.indexOf('@');
              if (atIndex != -1) {
                username = username.substring(0, atIndex);
              }
              final fillFieldsJs =
              '''
                (function() {
                  var u1 = document.getElementById("kullanici_adi");
                  var p1 = document.getElementById("kullanici_sifre");
                  if(u1) u1.value = "$username";
                  if(p1) p1.value = "${widget.password}";
                  var u2 = document.getElementById("username");
                  var p2 = document.getElementById("password");
                  if(u2) u2.value = "$username";
                  if(p2) p2.value = "${widget.password}";
                })();
              ''';
              await _controller.runJavaScript(fillFieldsJs);

              // 2. Wait a bit, then submit
              await Future.delayed(const Duration(milliseconds: 5000));
              final submitJs = '''
                (function() {
                  var btn = document.getElementById("loginbtn");
                  if(btn){ btn.click(); return; }
                  var u1 = document.getElementById("kullanici_adi");
                  var u2 = document.getElementById("username");
                  var form1 = u1 ? u1.closest("form") : null;
                  var form2 = u2 ? u2.closest("form") : null;
                  if(form1) form1.submit();
                  else if(form2) form2.submit();
                })();
              ''';
              await _controller.runJavaScript(submitJs);
            }
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Sayfa yüklenirken hata oluştu: ${error.description}',
                ),
              ),
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
