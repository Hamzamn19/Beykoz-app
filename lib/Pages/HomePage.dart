import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:beykoz/Pages/AttendancePage.dart';
import 'package:beykoz/Pages/ProfilePage.dart';
import 'package:beykoz/Pages/AllFeaturesPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:beykoz/Pages/SettingsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- YENİ IMPORT'LAR ---
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beykoz/data/features_data.dart';
import 'package:beykoz/Pages/EditFavoritesPage.dart';


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
  String? _userRole;
  bool _isLoadingRole = true;

  List<Widget> get _pages => [
    DesignedHomePage(userRole: _userRole), // Artık StatefulWidget
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
    if (_userRole == 'Student')
      AttendanceScreen(role: 'student')
    else if (_userRole == 'Teacher')
      AttendanceScreen(role: 'teacher')
    else
      AttendanceScreen(role: 'developer'),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _userRole = null;
        _isLoadingRole = false;
      });
      return;
    }
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(user.email)
        .get();
    if (doc.exists) {
      setState(() {
        _userRole = doc.data()?['role'] as String?;
        _isLoadingRole = false;
      });
    } else {
      // Örnek olarak, 'teachers' koleksiyonunda da arama yapabilirsiniz.
      // Şimdilik null bırakıyorum.
      setState(() {
        _userRole = null;
        _isLoadingRole = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingRole) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // Student: yoklama sekmesi sadece öğrenci, ayar çarkı yok
    // Teacher: yoklama sekmesi sadece öğretmen, ayar çarkı yok
    // Developer: hepsi açık
    final isStudent = _userRole == 'Student';
    final isTeacher = _userRole == 'Teacher';
    final isDeveloper = _userRole == 'Developer';

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
      floatingActionButton: isDeveloper
          ? _buildSettingsButton(context)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    // ... (Bu metot aynı kalıyor)
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, right: 16.0),
      child: FloatingActionButton(
        backgroundColor: const Color(0xFFECECEC),
        foregroundColor: const Color(0xFF802629),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}

// --- DEĞİŞİKLİK: DesignedHomePage artık bir StatefulWidget ---
class DesignedHomePage extends StatefulWidget {
  final String? userRole;
  const DesignedHomePage({super.key, this.userRole});

  @override
  State<DesignedHomePage> createState() => _DesignedHomePageState();
}

class _DesignedHomePageState extends State<DesignedHomePage> {
  static const Color primaryColor = Color(0xFF802629);
  static const Color cardColor = Color(0xFFECECEC);

  // --- YENİ DURUM DEĞİŞKENİ ---
  List<Map<String, dynamic>> _frequentlyUsedItems = [];
  bool _isLoadingFavorites = true;

  @override
  void initState() {
    super.initState();
    _loadUserFavorites();
  }

  // --- YENİ METOT: Kayıtlı favorileri yükler ---
  Future<void> _loadUserFavorites() async {
    setState(() {
      _isLoadingFavorites = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final favoriteLabels = prefs.getStringList('user_favorites');
    final allFeatures = FeaturesData.getAllFeatures();

    if (favoriteLabels == null || favoriteLabels.isEmpty) {
      // Kayıtlı favori yoksa, varsayılan listeyi kullan
      setState(() {
        _frequentlyUsedItems = [ ...FeaturesData.belgelerFeatures.take(8) ];
        _isLoadingFavorites = false;
      });
    } else {
      // Kayıtlı etiketlere göre özellikleri bul ve sıralı listeyi oluştur
      final loadedFavorites = favoriteLabels
          .map((label) {
        try {
          return allFeatures.firstWhere((feature) => feature['label'] == label);
        } catch (e) {
          return null; // Eğer bir özellik artık mevcut değilse null döner
        }
      })
          .where((item) => item != null) // null olanları filtrele
          .cast<Map<String, dynamic>>()
          .toList();
      setState(() {
        _frequentlyUsedItems = loadedFavorites;
        _isLoadingFavorites = false;
      });
    }
  }

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
              // --- DEĞİŞİKLİK: Düzenle butonu artık EditFavoritesPage'i açıyor ---
              _buildSectionTitle(
                'SIK KULLANILANLAR',
                onPressed: () async {
                  // EditFavoritesPage'e git ve bir sonuçla dönmesini bekle
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditFavoritesPage()),
                  );
                  // Eğer sayfa `true` sonucuyla kapandıysa (yani kayıt yapıldıysa),
                  // favori listesini yeniden yükle.
                  if (result == true) {
                    _loadUserFavorites();
                  }
                },
              ),
              const SizedBox(height: 12),
              // --- DEĞİŞİKLİK: Yükleme durumuna göre Grid veya Indicator göster ---
              _isLoadingFavorites
                  ? const Center(child: CircularProgressIndicator())
                  : _buildFrequentlyUsedGrid(),
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

  // ... _buildTopButtons metodu aynı kalıyor ...
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
                icon: Icons.settings,
                backgroundColor: const Color(0xFFECECEC),
                iconColor: const Color(0xFF802629),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
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


  // ... _buildCircularButton metodu aynı kalıyor ...
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

  // ... _buildSectionTitle metodu aynı kalıyor ...
  Widget _buildSectionTitle(String title, {VoidCallback? onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (onPressed != null)
            InkWell(
              onTap: onPressed,
              child: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Düzenle',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- DEĞİŞİKLİK: Bu metot artık sabit liste yerine _frequentlyUsedItems'ı kullanıyor ---
  Widget _buildFrequentlyUsedGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 0,
        childAspectRatio: 0.8,
      ),
      itemCount: _frequentlyUsedItems.length,
      itemBuilder: (context, index) {
        final item = _frequentlyUsedItems[index];
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

  // ... _buildAnnouncementCard metodu aynı kalıyor ...
  Widget _buildAnnouncementCard({
    required BuildContext context,
    required String imagePath,
    required String url,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(
              url: url,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
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