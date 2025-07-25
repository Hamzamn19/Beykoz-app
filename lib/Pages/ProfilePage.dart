import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:developer' as developer;
import 'package:beykoz/Pages/LoginPage.dart';
import 'package:beykoz/Services/theme_service.dart';
import 'package:provider/provider.dart';

// Student data model (no changes)
class Student {
  final String studentId;
  final String nameSurname;
  final String department;
  final String faculty;
  final String email;
  final String phoneNumber;
  String profileImageUrl;
  final String gpa; // Added GPA field

  Student({
    required this.studentId,
    required this.nameSurname,
    required this.department,
    required this.faculty,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl = '',
    this.gpa = 'N/A', // Default value
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      nameSurname: json['nameSurname'] ?? 'Not Available',
      studentId: json['studentId'] ?? 'Not Available',
      faculty: json['faculty'] ?? 'Not Available',
      department: json['department'] ?? 'Not Available',
      email: json['email'] ?? 'Not Available',
      phoneNumber: json['phoneNumber'] ?? 'Not Available',
      profileImageUrl: json['profileImageUrl'] ?? '',
      gpa: json['gpa'] ?? 'N/A',
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Color universityColor;
  late Color lightUniversityColor;

  Student? _student;
  bool _isLoading = true;
  String? _error;

  // Simple in-memory cache
  static Student? _cachedStudent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDataAndSetState();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final themeService = Provider.of<ThemeService>(context, listen: false);
    universityColor = themeService.isDarkMode 
        ? ThemeService.darkPrimaryColor 
        : ThemeService.lightPrimaryColor;
    lightUniversityColor = themeService.isDarkMode 
        ? ThemeService.darkSecondaryColor 
        : ThemeService.lightSecondaryColor;
  }

  Future<void> _fetchDataAndSetState({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Use cache if available and not forced to refresh
    if (!forceRefresh && _cachedStudent != null) {
      setState(() {
        _student = _cachedStudent;
        _isLoading = false;
      });
      return;
    }

    try {
      final result = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(builder: (context) => ProfileDataScraper()),
      );

      if (!mounted) return;

      if (result != null) {
        final student = Student.fromJson(result);
        _cachedStudent = student; // Cache the student data
        setState(() {
          _student = student;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Data fetching was cancelled by the user.';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      String errorMsg = e.toString();
      if (errorMsg.contains('login')) {
        errorMsg = 'Login failed. Please check your credentials.';
      } else if (errorMsg.contains('session')) {
        errorMsg = 'Session expired. Please log in again.';
      } else if (errorMsg.contains('network') ||
          errorMsg.contains('SocketException')) {
        errorMsg = 'No internet connection.';
      }
      setState(() {
        _error = errorMsg;
        _isLoading = false;
      });
    }
  }

  // Helper function to handle the Base64 profile image
  ImageProvider _getProfileImage(String imageUrl) {
    if (imageUrl.startsWith('data:image')) {
      try {
        final parts = imageUrl.split(',');
        if (parts.length == 2) {
          final imageBytes = base64Decode(parts[1]);
          return MemoryImage(imageBytes);
        }
      } catch (e) {
        developer.log(
          "Error decoding Base64 image: $e",
          name: 'ImageProcessing',
        );
      }
    }
    return const AssetImage('assets/images/default_avatar.png');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.isDarkMode 
              ? ThemeService.darkBackgroundColor 
              : ThemeService.lightBackgroundColor,
          body: RefreshIndicator(
            color: universityColor,
            onRefresh: () async {
              await _fetchDataAndSetState(forceRefresh: true);
            },
            child: _buildBody(),
          ),
        );
      },
    );
  }

  // This new build method decides what to show based on the state
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF802629)),
        ),
      );
    }

    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _fetchDataAndSetState(forceRefresh: true),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: universityColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'Settings',
                        Icons.settings,
                        () {
                          // Settings butonu için örnek fonksiyon
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Settings pressed')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildActionButton('Logout', Icons.logout, () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                      }, isDestructive: true),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      );
    }

    if (_student != null) {
      return _buildProfileView(_student!);
    }

    // Fallback case (e.g., user cancelled)
    return const Center(child: Text('Could not load profile data.'));
  }

  // This widget builds the main profile screen layout (no changes from before)
  Widget _buildProfileView(Student student) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: universityColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [universityColor, lightUniversityColor],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage: _getProfileImage(
                            student.profileImageUrl,
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      student.nameSurname,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      student.department,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Active Semester',
                      '2024-2025',
                      Icons.calendar_today,
                      universityColor,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      'CGPA', // Label changed to CGPA (or AGNO in TR)
                      student.gpa, // Use the dynamic GPA from the student object
                      Icons.trending_up,
                      lightUniversityColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Consumer<ThemeService>(
                builder: (context, themeService, child) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: themeService.isDarkMode 
                            ? ThemeService.darkTextPrimaryColor 
                            : ThemeService.lightTextPrimaryColor,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildModernInfoCard(
                icon: Icons.badge_outlined,
                label: 'Student ID',
                value: student.studentId,
                color: universityColor,
              ),
              _buildModernInfoCard(
                icon: Icons.apartment_outlined,
                label: 'Faculty',
                value: student.faculty,
                color: universityColor,
              ),
              _buildModernInfoCard(
                icon: Icons.mail_outline,
                label: 'Email',
                value: student.email,
                color: universityColor,
              ),
              _buildModernInfoCard(
                icon: Icons.phone_outlined,
                label: 'Phone Number',
                value: student.phoneNumber,
                color: universityColor,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Settings',
                      Icons.settings,
                      () {},
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildDarkModeToggle(),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton('Logout', Icons.logout, () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    }, isDestructive: true),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Add extra bottom padding to avoid being hidden by the bottom navigation bar
              const SizedBox(height: 80),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeService.isDarkMode 
                ? ThemeService.darkCardColor 
                : ThemeService.lightCardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeService.isDarkMode 
                      ? ThemeService.darkTextPrimaryColor 
                      : ThemeService.lightTextPrimaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: themeService.isDarkMode 
                      ? ThemeService.darkTextSecondaryColor 
                      : ThemeService.lightTextSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeService.isDarkMode 
                ? ThemeService.darkCardColor 
                : ThemeService.lightCardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeService.isDarkMode 
                            ? ThemeService.darkTextSecondaryColor 
                            : ThemeService.lightTextSecondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: themeService.isDarkMode 
                            ? ThemeService.darkTextPrimaryColor 
                            : ThemeService.lightTextPrimaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
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

  Widget _buildDarkModeToggle() {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: () => themeService.toggleTheme(),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeService.isDarkMode
                  ? Colors.orange.shade50
                  : universityColor.withOpacity(0.1),
              foregroundColor: themeService.isDarkMode ? Colors.orange : universityColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  themeService.isDarkMode ? 'Light Mode' : 'Dark Mode',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive
              ? Colors.red.shade50
              : universityColor.withOpacity(0.1),
          foregroundColor: isDestructive ? Colors.red : universityColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDataScraper extends StatefulWidget {
  const ProfileDataScraper({super.key});

  @override
  _ProfileDataScraperState createState() => _ProfileDataScraperState();
}

class _ProfileDataScraperState extends State<ProfileDataScraper> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  // Add a timeout duration for scraping (e.g., 40 seconds)
  static const Duration scrapeTimeout = Duration(seconds: 40);
  bool _scrapeStarted = false;

  Map<String, dynamic>? _scrapedProfileData; // For multi-step scraping

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                  _errorMessage = null;
                  _scrapeStarted = false;
                });
              }
            });
          },
          onPageFinished: (String url) {
            // Multi-step scraping logic
            if (url.contains('ogrenci/kisisel') && _scrapedProfileData == null) {
              _scrapeProfileData();
            } else if (url.contains('belge/transkript')) {
              _scrapeGpa();
            } else if (url.contains('login') || url.contains('giris')) {
              setState(() {
                _hasError = true;
                _errorMessage = 'Login failed. Please check your credentials.';
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              });
            }
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage =
                  'No internet connection or failed to load the page.';
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://ois.beykoz.edu.tr/ogrenciler/ogrenci/kisisel'),
      );
  }

  // Step 1: Scrape profile data
  Future<void> _scrapeProfileData() async {
    const String jsCode = """
      (function() {
        function findElementTextByLabelText(labelText) {
          const allLabels = document.querySelectorAll('label');
          for (let i = 0; i < allLabels.length; i++) {
            if (allLabels[i].innerText.trim() === labelText) {
              const element = allLabels[i].parentElement.nextElementSibling;
              if (element && element.classList.contains('element')) {
                return element.innerText.trim();
              }
            }
          }
          return 'Not Available';
        }
        const name = findElementTextByLabelText('Name');
        const surname = findElementTextByLabelText('Surname');
        const studentId = findElementTextByLabelText('Student ID');
        const facultyText = findElementTextByLabelText('Faculty Code');
        const departmentText = findElementTextByLabelText('Department');
        const email = document.querySelector('input[name="iletisim_416287"]')?.value || '';
        const phone = document.querySelector('input[name="iletisim_416286"]')?.value || '';
        const profileImageUrl = document.querySelector('img[width="120"]')?.src || '';
        
        const faculty = facultyText.includes('-') ? facultyText.split('-')[1].trim() : facultyText;
        const department = departmentText.includes('-') ? departmentText.split('-')[1].trim() : departmentText;
        return {
          'nameSurname': name + ' ' + surname,
          'studentId': studentId,
          'faculty': faculty,
          'department': department,
          'email': email,
          'phoneNumber': phone,
          'profileImageUrl': profileImageUrl
        };
      })();
    """;
    try {
      final result = await _controller.runJavaScriptReturningResult(jsCode);
      if (result != null && result.toString() != 'null') {
        final decodedResult =
            jsonDecode(result.toString()) as Map<String, dynamic>;
        _scrapedProfileData = decodedResult;
        _controller.loadRequest(
          Uri.parse('https://ois.beykoz.edu.tr/ogrenciler/belge/transkript'),
        );
      } else {
        throw Exception('Failed to parse profile data.');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
          _errorMessage = 'An error occurred while fetching profile data: $e';
        });
      }
    }
  }

  // Step 2: Scrape GPA and return all data
  Future<void> _scrapeGpa() async {
    const String gpaJsCode = """
      (function() {
        const gnoSpans = document.querySelectorAll('span.gno');
        let gpa = 'N/A';
        for (const span of gnoSpans) {
          const text = span.innerText.trim();
          if (text.startsWith('AGNO') || text.startsWith('CGPA')) {
            const parts = text.split(':');
            if (parts.length > 1) {
              gpa = parts[1].trim();
              break;
            }
          }
        }
        return gpa;
      })();
    """;
    try {
      final gpaResult = await _controller.runJavaScriptReturningResult(
        gpaJsCode,
      );
      String gpa = 'N/A';
      if (gpaResult != null && gpaResult.toString() != 'null') {
        gpa = gpaResult.toString().replaceAll('"', '').trim();
      }
      if (_scrapedProfileData != null) {
        _scrapedProfileData!['gpa'] = gpa;
        if (mounted) {
          Navigator.pop(
            context,
            _scrapedProfileData,
          );
        }
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to fetch data from the page.';
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profil verisi bulunamadı.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'An error occurred while fetching data: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Profile Data'),
        backgroundColor: const Color(0xFF802629),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF802629)),
              ),
            ),
          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage ?? 'An unknown error occurred.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Reset state and reload
                        _scrapedProfileData = null;
                        _controller.loadRequest(
                          Uri.parse(
                            'https://ois.beykoz.edu.tr/ogrenciler/ogrenci/kisisel',
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF802629),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
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
}
