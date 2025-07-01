import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:beykoz/Pages/AttendancePage.dart';
import 'package:beykoz/Pages/ProfilePage.dart';
import 'package:beykoz/Pages/AllFeaturesPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Main widget containing the home screen and Bottom Navigation Bar logic
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
      AttendanceScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.web), label: 'OIS'),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Online'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Yoklama',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF802629),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- NEW HOME PAGE DESIGN WIDGET ---
class DesignedHomePage extends StatelessWidget {
  const DesignedHomePage({super.key});

  static const Color primaryColor = Color(0xFF802629);
  static const Color cardColor = Color(0xFFECECEC);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopButtons(context),
              const SizedBox(height: 24),
              _buildSectionTitle('SIK KULLANILANLAR'),
              const SizedBox(height: 12),
              _buildFrequentlyUsedGrid(),
              const SizedBox(height: 5),
              Center(
              child :ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const AllFeaturesSheet(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 150),
                ),
                child: const Text(
                  'TÜMÜ',
                  style: TextStyle(fontSize: 15, color: Color(0xFF802629)),
                ),
              ),
              ),
              const SizedBox(height: 15),
              _buildSectionTitle('DUYURULAR'),
              const SizedBox(height: 12),

              // DEĞİŞİKLİK 1: Kartlar artık tıklanabilir ve ilgili linklere yönlendirir
              _buildAnnouncementCard(
                context: context,
                imagePath: 'assets/images/mezuniyettoreni.jpg',
                url: 'https://www.beykoz.edu.tr/haber/5581-2025-mezuniyet-toreni',
              ),
              const SizedBox(height: 16),
              _buildAnnouncementCard(
                context: context,
                imagePath: 'assets/images/yazogretimi.jpg',
                url: 'https://www.beykoz.edu.tr/haber/5616-2024-2025-yaz-ogretiminde-acilabilecek-dersler-duyurusu',
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebViewPage(
                    url: 'https://www.beykoz.edu.tr/',
                  ),
                ),
              );
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 48,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularButton(
                icon: Icons.person,
                backgroundColor: const Color(0xFFECECEC),
                iconColor: const Color(0xFF802629),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              _buildCircularButton(
                icon: Icons.notifications,
                backgroundColor: const Color(0xFF802629),
                iconColor: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        backgroundColor: backgroundColor,
      ),
      child: Icon(icon, color: iconColor, size: 30),
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
    // ... (This part of the code is unchanged)
    final List<Map<String, dynamic>> frequentlyUsed = [
      {
        'label': 'Transkript',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/transkript',
        'icon': FontAwesomeIcons.fileInvoice, // DEĞİŞTİRİLDİ
      },
      {
        'label': 'Karne',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/ogrkarne',
        'icon': FontAwesomeIcons.award, // DEĞİŞTİRİLDİ
      },
      {
        'label': 'Ders Programı',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/ogrdersprogrami',
        'icon': FontAwesomeIcons.calendarWeek, // DEĞİŞTİRİLDİ
      },
      {
        'label': 'Hazırlık Karne',
        'url': 'https://ois.beykoz.edu.tr/hazirlik/hazirliksinav/ogrpreptranskript',
        'icon': FontAwesomeIcons.bookReader, // DEĞİŞTİRİLDİ
      },
      {
        'label': 'Ders Onay Belgesi',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/dersdanismanonay',
        'icon': FontAwesomeIcons.stamp, // DEĞİŞTİRİLDİ
      },
      {
        'label': 'Kesin Kayıt Belgesi',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/kesinkayitbelgesi',
        'icon': FontAwesomeIcons.idCard, // DEĞİŞTİRİLDİ
      },
      {
        'label': 'Online Belge Talep',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belgetalep/duzenle2',
        'icon': FontAwesomeIcons.paperPlane, // DEĞİŞTİRİLDİ
      },
      {
        'label': 'Sınav Programı',
        'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/sinavprogrami',
        'icon': FontAwesomeIcons.calendarCheck, // DEĞİŞTİRİLDİ
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
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
                width: 56.75,
                height: 56.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF802629), Color(0xFFB2453C)],
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
                child: Icon(item['icon'], color: Colors.white, size: 30),
              ),
              const SizedBox(height: 5),
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
            ],
          ),
        );
      },
    );
  }

  // DEĞİŞİKLİK 2: _buildAnnouncementCard metodu artık tıklanabilir ve dinamik.
  Widget _buildAnnouncementCard({
    required BuildContext context,
    required String imagePath,
    required String url,
  }) {
    return InkWell(
      onTap: () {
        // Tıklandığında WebViewPage'i aç ve ilgili URL'i gönder.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(
              url: url,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16), // Tıklama efektinin köşelerini yuvarlak yapar
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: cardColor, // Resim yüklenemezse görünecek arka plan rengi
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath), // Gösterilecek resim
            fit: BoxFit.cover, // Resmin tüm alanı kaplamasını sağlar
          ),
        ),
      ),
    );
  }
}

// --- WEBVIEW PAGE ---
// ... (This part of the code is unchanged)
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
  bool _canGoBack = false;
  bool _canGoForward = false;
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
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                });
              }
            });
          },
          onPageFinished: (String url) async {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await _updateNavigationState();
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            });

            if (widget.username != null && widget.password != null) {
              String username = widget.username!;
              final atIndex = username.indexOf('@');
              if (atIndex != -1) {
                username = username.substring(0, atIndex);
              }
              final loginJs =
              '''
                (function() {
                  var username = "$username";
                  var password = "${widget.password}";
                  var u1 = document.getElementById("kullanici_adi");
                  var p1 = document.getElementById("kullanici_sifre");
                  var u2 = document.getElementById("username");
                  var p2 = document.getElementById("password");
                  function fillField(field, value) {
                    if (field) {
                      field.focus();
                      field.value = value;
                      field.dispatchEvent(new Event('input', { bubbles: true }));
                      field.dispatchEvent(new Event('change', { bubbles: true }));
                    }
                  }
                  fillField(u1, username);
                  fillField(p1, password);
                  fillField(u2, username);
                  fillField(p2, password);
                })();
              ''';
              await _controller.runJavaScript(loginJs);
            }
          },
          onWebResourceError: (WebResourceError error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sayfa yüklenemedi: ${error.description}'),
                  ),
                );
              }
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _updateNavigationState() async {
    final canGoBack = await _controller.canGoBack();
    final canGoForward = await _controller.canGoForward();
    if (mounted) {
      setState(() {
        _canGoBack = canGoBack;
        _canGoForward = canGoForward;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        if (await _controller.canGoBack()) {
          await _controller.goBack();
          _updateNavigationState();
        } else {
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF802629),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: const Color(0xFF802629),
                      onPressed: _canGoBack
                          ? () async {
                              await _controller.goBack();
                              _updateNavigationState();
                            }
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      color: const Color(0xFF802629),
                      onPressed: _canGoForward
                          ? () async {
                              await _controller.goForward();
                              _updateNavigationState();
                            }
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      color: const Color(0xFF802629),
                      onPressed: () {
                        _controller.reload();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}