import 'package:beykoz/Pages/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:beykoz/Pages/AttendancePage.dart';
import 'package:beykoz/Pages/AllFeaturesPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// will be used for the logo
import 'package:beykoz/Pages/SettingsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beykoz/data/features_data.dart';
import 'package:beykoz/Pages/EditFavoritesPage.dart';
import 'package:beykoz/Services/theme_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Transportation.dart';
import 'AcademicStaffPage.dart';
import 'RootPage.dart';
import 'package:beykoz/Pages/MessengerPage.dart';
import 'package:beykoz/Pages/demo/CourseSchedulePage.dart';
import 'package:beykoz/Pages/demo/transcript_page.dart';

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
  bool _isDrawerOpen = false;

  void _setDrawerOpen(bool value) {
    setState(() {
      _isDrawerOpen = value;
    });
  }

  List<Widget> get _pages => [
    DesignedHomePage(
      userRole: _userRole,
      isDrawerOpen: _isDrawerOpen,
      setDrawerOpen: _setDrawerOpen,
    ),
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Student: yoklama sekmesi sadece öğrenci, ayar çarkı yok
    // Teacher: yoklama sekmesi sadece öğretmen, ayar çarkı yok
    // Developer: hepsi açık
    final isStudent = _userRole == 'Student';
    final isTeacher = _userRole == 'Teacher';
    final isDeveloper = _userRole == 'Developer';

    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.isDarkMode
              ? ThemeService.darkBackgroundColor
              : ThemeService.lightBackgroundColor,
          body: IndexedStack(index: _selectedIndex, children: _pages),
          bottomNavigationBar: _isDrawerOpen
              ? null
              : BottomNavigationBar(
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
                      icon: Icon(Icons.check_circle),
                      label: 'Yoklama',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white70,
                  backgroundColor: themeService.isDarkMode
                      ? ThemeService.darkPrimaryColor
                      : ThemeService.lightPrimaryColor,
                  type: BottomNavigationBarType.fixed,
                  onTap: _onItemTapped,
                ),
          floatingActionButton: isDeveloper
              ? _buildSettingsButton(context)
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        );
      },
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 40.0, right: 16.0),
          child: FloatingActionButton(
            backgroundColor: themeService.isDarkMode
                ? ThemeService.darkCardColor
                : const Color(0xFFECECEC),
            foregroundColor: themeService.isDarkMode
                ? ThemeService.darkPrimaryColor
                : const Color(0xFF802629),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            child: const Icon(Icons.settings),
          ),
        );
      },
    );
  }
}

// DesignedHomePage artık bir StatefulWidget
class DesignedHomePage extends StatefulWidget {
  final String? userRole;
  final bool isDrawerOpen;
  final void Function(bool) setDrawerOpen;
  final void Function(int)? setSelectedIndex;
  const DesignedHomePage({
    super.key,
    this.userRole,
    required this.isDrawerOpen,
    required this.setDrawerOpen,
    this.setSelectedIndex,
  });

  @override
  State<DesignedHomePage> createState() => _DesignedHomePageState();
}

class _DesignedHomePageState extends State<DesignedHomePage>
    with SingleTickerProviderStateMixin {
  late Color primaryColor;
  late Color cardColor;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  String? _userName;
  List<Map<String, dynamic>> _frequentlyUsedItems = [];
  bool _isLoadingFavorites = true;

  @override
  void initState() {
    super.initState();
    _loadUserFavorites();
    _fetchUserName();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Remove local _isDrawerOpen, use widget.isDrawerOpen and widget.setDrawerOpen
  void _toggleDrawer() {
    widget.setDrawerOpen(!widget.isDrawerOpen);
    if (!widget.isDrawerOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  // Function to launch URL for sidebar items
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      throw Exception('Bağlantı açılamadı: $url');
    }
  }

  // Fetch user name from Firebase
  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // First try to get user role and student number from students collection
      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(user.email)
          .get();

      if (studentDoc.exists) {
        final role = studentDoc.data()?['role'] as String?;

        if (role == 'teachers') {
          // For teachers, fetch from teachers collection using email
          final teacherDoc = await FirebaseFirestore.instance
              .collection('teachers')
              .doc(user.email)
              .get();

          if (teacherDoc.exists) {
            setState(() {
              _userName = teacherDoc.data()?['name'] as String? ?? 'Kullanıcı';
            });
          } else {
            setState(() {
              _userName = 'Kullanıcı';
            });
          }
        } else {
          // For students, get student number and fetch from students collection
          final studentNumber = studentDoc.data()?['studentNumber'] as String?;

          if (studentNumber != null) {
            final nameDoc = await FirebaseFirestore.instance
                .collection('students')
                .doc(studentNumber)
                .get();

            if (nameDoc.exists) {
              setState(() {
                _userName = nameDoc.data()?['name'] as String? ?? 'Kullanıcı';
              });
            } else {
              setState(() {
                _userName = 'Kullanıcı';
              });
            }
          } else {
            setState(() {
              _userName = 'Kullanıcı';
            });
          }
        }
      } else {
        setState(() {
          _userName = 'Kullanıcı';
        });
      }
    } else {
      setState(() {
        _userName = 'Kullanıcı';
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final themeService = Provider.of<ThemeService>(context, listen: false);
    primaryColor = themeService.isDarkMode
        ? ThemeService.darkPrimaryColor
        : ThemeService.lightPrimaryColor;
    cardColor = themeService.isDarkMode
        ? ThemeService.darkCardColor
        : ThemeService.lightCardColor;
  }

  Future<void> _loadUserFavorites() async {
    setState(() {
      _isLoadingFavorites = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final favoriteLabels = prefs.getStringList('user_favorites');
    final allFeatures = FeaturesData.getAllFeatures();

    if (favoriteLabels == null || favoriteLabels.isEmpty) {
      setState(() {
        _frequentlyUsedItems = [...FeaturesData.belgelerFeatures.take(8)];
        _isLoadingFavorites = false;
      });
    } else {
      final loadedFavorites = favoriteLabels
          .map((label) {
            try {
              return allFeatures.firstWhere(
                (feature) => feature['label'] == label,
              );
            } catch (e) {
              return null;
            }
          })
          .where((item) => item != null)
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
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            // Open sidebar: swipe right (velocity > 0), only if closed
            if (!widget.isDrawerOpen &&
                details.primaryVelocity != null &&
                details.primaryVelocity! > 300) {
              _toggleDrawer();
            }
            // Close sidebar: swipe left (velocity < 0), only if open
            if (widget.isDrawerOpen &&
                details.primaryVelocity != null &&
                details.primaryVelocity! < -300) {
              _toggleDrawer();
            }
          },
          child: Stack(
            children: [
              // --- GESTURE STRIP FOR OPENING SIDEBAR ---
              if (!widget.isDrawerOpen)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 24,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity != null &&
                          details.primaryVelocity! > 300) {
                        _toggleDrawer();
                      }
                    },
                    child: const SizedBox.expand(),
                  ),
                ),
              // Main content with animations
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      _slideAnimation.value *
                          (MediaQuery.of(context).size.width * 0.8),
                      0,
                    ),
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: SafeArea(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTopButtons(context),
                                const SizedBox(height: 24),
                                _buildSectionTitle(
                                  'FAVORİLER',
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EditFavoritesPage(),
                                      ),
                                    );
                                    if (result == true) {
                                      _loadUserFavorites();
                                    }
                                  },
                                ),
                                const SizedBox(height: 12),
                                _isLoadingFavorites
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : _buildFrequentlyUsedGrid(),
                                const SizedBox(height: 5),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) =>
                                            const AllFeaturesSheet(),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: cardColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 150,
                                      ),
                                    ),
                                    child: Text(
                                      'TÜMÜ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                _buildSectionTitle('DUYURULAR'),
                                const SizedBox(height: 12),
                                _buildAnnouncementCard(
                                  context: context,
                                  imagePath:
                                      'assets/images/mezuniyettoreni.jpg',
                                  url:
                                      'https://www.beykoz.edu.tr/haber/5581-2025-mezuniyet-toreni',
                                ),
                                const SizedBox(height: 16),
                                _buildAnnouncementCard(
                                  context: context,
                                  imagePath: 'assets/images/yazogretimi.jpg',
                                  url:
                                      'https://www.beykoz.edu.tr/haber/5616-2024-2025-yaz-ogretiminde-acilabilecek-dersler-duyurusu',
                                ),
                                const SizedBox(height: 90),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (widget.isDrawerOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _toggleDrawer,
                    child: Container(color: Colors.black.withOpacity(0.3)),
                  ),
                ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      -MediaQuery.of(context).size.width *
                          0.8 *
                          (1 - _slideAnimation.value),
                      0,
                    ),
                    child: _buildSidebar(context, themeService),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopButtons(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        // Üst bölümün yüksekliğini sabit tutmak için bir SizedBox ekliyoruz.
        return SizedBox(
          height: 48, // Logonun orijinal yüksekliği ile aynı
          child: Stack(
            // <-- Yapıyı Stack olarak değiştiriyoruz
            children: [
              // 1. Ortalanmış Logo
              Center(
                // <-- Logoyu tam ortaya almak için Center widget'ı kullanıyoruz
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
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    height: 48,
                  ),
                ),
              ),

              // 2. Sola Yaslanmış Hamburger Butonu
              Align(
                alignment: Alignment.centerLeft,
                child: _buildCircularButton(
                  icon: Icons.menu,
                  backgroundColor: themeService.isDarkMode
                      ? ThemeService.darkCardColor
                      : const Color(0xFFECECEC),
                  iconColor: themeService.isDarkMode
                      ? ThemeService.darkPrimaryColor
                      : const Color(0xFF802629),
                  onPressed: _toggleDrawer,
                ),
              ),

              // 3. Sağa Yaslanmış Butonlar
              Align(
                // <-- Butonları sağa yaslamak için Align widget'ı kullanıyoruz
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Row'un sadece çocuklar kadar yer kaplamasını sağlar
                  children: [
                    _buildCircularButton(
                      icon: Icons.settings,
                      backgroundColor: themeService.isDarkMode
                          ? ThemeService.darkCardColor
                          : const Color(0xFFECECEC),
                      iconColor: themeService.isDarkMode
                          ? ThemeService.darkPrimaryColor
                          : const Color(0xFF802629),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

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

  Widget _buildFrequentlyUsedGrid() {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        // ... (This part of the code is unchanged)
        final List<Map<String, dynamic>> frequentlyUsed = [
          {
            'label': 'Transkript',
            'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/transkript',
            'icon': FontAwesomeIcons.fileInvoice,
          },
          {
            'label': 'Karne',
            'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/ogrkarne',
            'icon': FontAwesomeIcons.award,
          },
          {
            'label': 'Ders Programı',
            'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/ogrdersprogrami',
            'icon': FontAwesomeIcons.calendarWeek,
          },
          {
            'label': 'Hazırlık Karne',
            'url':
                'https://ois.beykoz.edu.tr/hazirlik/hazirliksinav/ogrpreptranskript',
            'icon': FontAwesomeIcons.bookReader,
          },
          {
            'label': 'Ders Onay Belgesi',
            'url':
                'https://ois.beykoz.edu.tr/ogrenciler/belge/dersdanismanonay',
            'icon': FontAwesomeIcons.stamp,
          },
          {
            'label': 'Kesin Kayıt Belgesi',
            'url':
                'https://ois.beykoz.edu.tr/ogrenciler/belge/kesinkayitbelgesi',
            'icon': FontAwesomeIcons.idCard,
          },
          {
            'label': 'Online Belge Talep',
            'url': 'https://ois.beykoz.edu.tr/ogrenciler/belgetalep/duzenle2',
            'icon': FontAwesomeIcons.paperPlane,
          },
          {
            'label': 'Sınav Programı',
            'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/sinavprogrami',
            'icon': FontAwesomeIcons.calendarCheck,
          },
        ];
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
              // ***** بداية التعديل الكامل لمنطق النقر *****
              onTap: () {
                // التحقق إذا كان الزر هو "Ders Programı"
                if (item['label'] == 'Ders Programı') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CourseSchedulePage(),
                    ),
                  );
                }
                // التحقق إذا كان الزر هو "Transkript"
                else if (item['label'] == 'Transkript') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // الانتقال إلى الصفحة الجديدة التي أنشأناها
                      builder: (context) => const TranskriptEkrani(),
                    ),
                  );
                }
                // لجميع الأزرار الأخرى
                else {
                  // الحفاظ على السلوك الأصلي وفتح WebView
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
                }
              },
              // ***** نهاية التعديل *****
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
                    style: TextStyle(
                      color: themeService.isDarkMode
                          ? ThemeService.darkTextPrimaryColor
                          : Color(0xFF802629),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
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
          MaterialPageRoute(builder: (context) => WebViewPage(url: url)),
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

  // Minimalistic Sidebar
  Widget _buildSidebar(BuildContext context, ThemeService themeService) {
    final List<_SidebarItem> sidebarItems = [
      _SidebarItem(
        icon: Icons.podcasts,
        color: Colors.green,
        label: 'Spotify Podcast',
        onTap: () =>
            _launchUrl('https://open.spotify.com/show/3PDrCJDBv8GK7B3slOm9ZE'),
      ),
      _SidebarItem(
        icon: Icons.menu_book,
        color: Colors.blue,
        label: 'Beykoz Yayınları',
        onTap: () => _launchUrl(
          'https://www.beykoz.edu.tr/icerik/2872-beykoz-yayinlari',
        ),
      ),
      _SidebarItem(
        icon: Icons.local_library,
        color: Colors.orange,
        label: 'Kütüphane',
        onTap: () =>
            _launchUrl('https://www.beykoz.edu.tr/icerik/3233-kutuphane'),
      ),
      _SidebarItem(
        icon: Icons.account_balance,
        color: Colors.purple,
        label: 'Kurumsal Kimlik\nKılavuzu',
        onTap: () => _launchUrl(
          'https://www.beykoz.edu.tr/icerik/90-kurumsal-kimlik-kilavuzu',
        ),
      ),
      _SidebarItem(
        icon: Icons.newspaper,
        color: Colors.red,
        label: 'Basında Beykoz',
        onTap: () =>
            _launchUrl('https://www.beykoz.edu.tr/haber/92-basinda-beykoz'),
      ),
      _SidebarItem(
        icon: Icons.campaign,
        color: Colors.teal,
        label: 'Basın Bültenleri',
        onTap: () => _launchUrl(
          'https://www.beykoz.edu.tr/icerik/5274-basin-bultenleri',
        ),
      ),
      _SidebarItem(
        icon: Icons.directions_bus,
        color: const Color(0xFF0A285F),
        label: 'Ulaşım ve İletişim',
        onTap: () {
          _toggleDrawer();
          Future.delayed(const Duration(milliseconds: 250), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransportationPage()),
            );
          });
        },
      ),
      _SidebarItem(
        icon: Icons.school,
        color: Colors.brown,
        label: 'Akademik Kadro',
        onTap: () {
          _toggleDrawer();
          Future.delayed(const Duration(milliseconds: 250), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AcademicStaffPage()),
            );
          });
        },
      ),
      _SidebarItem(
        icon: Icons.web,
        color: Colors.indigo,
        label: 'Web Portal',
        onTap: () {
          _toggleDrawer();
          Future.delayed(const Duration(milliseconds: 250), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WebviewPageSelector()),
            );
          });
        },
      ),
    ];

    final backgroundColor = themeService.isDarkMode
        ? ThemeService.darkBackgroundColor
        : ThemeService.lightBackgroundColor;
    final textColor = themeService.isDarkMode
        ? ThemeService.darkTextPrimaryColor
        : ThemeService.lightTextPrimaryColor;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: greeting and close icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: themeService.isDarkMode
                        ? ThemeService.darkPrimaryColor
                        : ThemeService.lightPrimaryColor,
                    radius: 22,
                    child: Icon(Icons.school, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hoş Geldiniz',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          _userName ?? 'Kullanıcı',
                          style: TextStyle(
                            color: textColor.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Removed the IconButton (cross/close)
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Önemli Bağlantılar ve Servisler',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              // Minimalistic menu list
              Expanded(
                child: ListView.separated(
                  itemCount: sidebarItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    final item = sidebarItems[index];
                    return ListTile(
                      leading: Icon(item.icon, color: item.color, size: 24),
                      title: Text(
                        item.label,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      onTap: item.onTap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      hoverColor: themeService.isDarkMode
                          ? Colors.white.withOpacity(0.04)
                          : Colors.black.withOpacity(0.03),
                      splashColor: themeService.isDarkMode
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.06),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper class for sidebar items
class _SidebarItem {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });
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
