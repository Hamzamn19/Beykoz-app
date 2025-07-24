import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  // Üniversite rengini tanımlıyoruz
  final Color universityColor = const Color(0xFF802629);
  final Color lightUniversityColor = const Color(0xFFB85A5E);

  // Örnek kullanıcı verileri
  final String studentId = '1111111111';
  final String nameSurname = 'Ayşe Yılmaz';
  final String department = 'Bilgisayar Mühendisliği';
  final String faculty = 'Mühendislik ve Mimarlık Fakültesi';
  final String phoneNumber = '+90 5XX XXX XX XX';
  final String profileImageUrl = 'https://via.placeholder.com/150';

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? 'E-posta bulunamadı';
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern SliverAppBar
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
                      // Profil resmi ile modern shadow
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
                            backgroundImage: NetworkImage(profileImageUrl),
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // İsim
                      Text(
                        nameSurname,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        department,
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
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                onPressed: () {
                  // Düzenleme sayfasına git
                },
              ),
            ],
          ),

          // İçerik
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFFF8F9FA)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // İstatistik kartları
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Aktif Dönem',
                            '2024-2025',
                            Icons.calendar_today,
                            universityColor,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildStatCard(
                            'GNO',
                            '3.03',
                            Icons.trending_up,
                            lightUniversityColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Bilgi başlığı
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Kişisel Bilgiler',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Bilgi kartları
                    _buildModernInfoCard(
                      icon: Icons.badge_outlined,
                      label: 'Öğrenci Numarası',
                      value: studentId,
                      color: universityColor,
                    ),
                    _buildModernInfoCard(
                      icon: Icons.apartment_outlined,
                      label: 'Fakülte',
                      value: faculty,
                      color: universityColor,
                    ),
                    _buildModernInfoCard(
                      icon: Icons.mail_outline,
                      label: 'E-posta',
                      value: email,
                      color: universityColor,
                    ),
                    _buildModernInfoCard(
                      icon: Icons.phone_outlined,
                      label: 'Telefon Numarası',
                      value: phoneNumber,
                      color: universityColor,
                    ),

                    const SizedBox(height: 30),

                    // Alt butonlar
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            'Ayarlar',
                            Icons.settings,
                            () {},
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildActionButton(
                            'Çıkış Yap',
                            Icons.logout,
                            () async {
                              // Loading dialog göster
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              try {
                                // Firebase'den çıkış yap
                                await FirebaseAuth.instance.signOut();

                                // Loading dialog'u kapat
                                Navigator.of(context).pop();

                                // Login sayfasına git ve tüm önceki sayfaları temizle
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login',
                                  (Route<dynamic> route) => false,
                                );
                              } catch (e) {
                                // Hata durumunda loading dialog'u kapat
                                Navigator.of(context).pop();

                                // Hata mesajı göster
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Çıkış yapılırken hata oluştu: $e',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            isDestructive: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // İstatistik kartı
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Modern bilgi kartı
  Widget _buildModernInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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
  }

  // Aksiyon butonu
  Widget _buildActionButton(
    String title,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return Container(
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

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Giriş Yap')),
      body: Center(child: Text('Login Page')),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      title: 'Profil Sayfası',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProfilePage(),
      routes: {
        '/login': (context) => LoginPage(), // LoginPage widget'ını buraya ekle
      },
    ),
  );
}
