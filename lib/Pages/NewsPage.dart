import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:beykoz/Services/theme_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  static const Color primaryColor = Color(0xFF802629);
  static const Color cardColor = Color(0xFFECECEC);

  // Örnek post verileri
  List<Map<String, dynamic>> posts = [
    {
      'id': 1,
      'adminName': 'Yöntek Kulübü',
      'adminAvatar': 'assets/images/beykoz.logo.png',
      'timestamp': '2 saat önce',
      'content':
          '🎯 Beykoz Üniversitesi YÖNTEK Kulübü\'nden Bir İlk Daha!\n💻 Geleceğin Başarı Stratejileri 2025 Kayıt Formu Yayında! : https://forms.gle/BvmWdeodPDP77ij8A\n\nGeleceği şekillendiren iş dünyasına bir adım daha yaklaşmak ister misin?\n\nBeykoz Üniversitesi Yönetim ve Teknoloji Kulübü (YÖNTEK) olarak; teknoloji tutkunlarını, psikoloji severleri, ilham dolu hikayelerin aşığı olanları ve yazılım meraklılarını bir araya getirecek büyük bir zirveye imza atıyoruz!\n\n🔹 Alanında uzman konuşmacılar\n🔹 İlham veren başarı hikayeleri\n🔹 Kariyer fırsatları, staj olanakları ve networking şansı\n🔹 Kahoot yarışmalı eğlenceli oturumlar\n🔹 Katılımcılara özel sertifikalı hediye eğitimler\n\n📍 Zirve Detayları\n📅 Tarih: 16 Mayıs Cuma\n📌 Yer: Beykoz Üniversitesi Lisans Yerleşkesi – Konferans Salonu (4. Kat)\n🕐 Saat: 12.00 – 15.30\n\n🎁 Katılımcılara Hediye Eğitimler ve Ödüller:\n\n🏆 Birinci olan katılımcıya ve kulüp üyelerine özel:\n\nDevNet Associate Eğitimi\n▫️ 70 saat – 23 uygulamalı lab\n▫️ Sertifikalı ve rozetli\n\nEthical Hacker Eğitimi\n▫️ 70 saat – 34 uygulamalı lab\n▫️ Sertifikalı ve rozetli\n\n🎓 Zirveye katılan tüm öğrencilere:\n\nNetwork Defense – 27 saat (Beginner düzey, rozetli)\n\nPython 1 – 30 saat (rozetli)\n\nPython 2 – 40 saat (rozetli)\n\nCyber Threat Management – 16 saat (rozetli)\n\n💥 2. Oturumda Kahoot Yarışması Sizi Bekliyor!\nBilgini sınamak, eğlenmek ve ödüller kazanmak için bu fırsatı kaçırma!\n\n📝 Katılım ücretsizdir.\n📢 Not: Tüm katılımcılara e-sertifika verilecektir.\n📌 Kontenjan sınırlıdır – hemen kayıt ol!\n\n\nMini Zirve!!!',
      'image': 'assets/images/yontek2.png',
      'likes': 45,
      'comments': 12,
      'isLiked': false,
    },
    {
      'id': 2,
      'adminName': 'Beykoz Üniversitesi',
      'adminAvatar': 'assets/images/beykoz.logo.png',
      'timestamp': '5 saat önce',
      'content':
          'Üniversitemiz spor festivaline tüm öğrencilerimizi davet ediyoruz! 🎉 Kayıtlar başladı.',
      'image': 'assets/images/festival.png',
      'likes': 128,
      'comments': 34,
      'isLiked': true,
    },
    {
      'id': 3,
      'adminName': 'Beykoz Üniversitesi',
      'adminAvatar': 'assets/images/beykoz.logo.png',
      'timestamp': '1 gün önce',
      'content':
          'Final sınavları programı açıklandı. Öğrenci bilgi sisteminden kontrol edebilirsiniz.',
      'image': null,
      'likes': 89,
      'comments': 23,
      'isLiked': false,
    },
    {
      'id': 4,
      'adminName': 'Bilgisayar Mühendisliği Kulübü',
      'adminAvatar': 'assets/images/beykoz.logo.png',
      'timestamp': '3 saat önce',
      'content':
          'Mühendislik dünyasının en yaratıcı projelerini bir araya getiren organizasyonumuzda, Yılın Mühendislik Projesi Ödülünün sahibini çok yakında açıklıyoruz!\n\nBirbirinden etkileyici, yenilikçi ve ilham verici projeler arasından seçim yapmak bizler için oldukça zordu.\n\n📅 Ödül törenimizde büyük heyecana ortak olun, mühendisliğin geleceğine yön veren projeyi birlikte kutlayalım!',
      'image': 'assets/images/engineering.png',
      'likes': 67,
      'comments': 19,
      'isLiked': false,
    },
    {
      'id': 5,
      'adminName': 'Yapay Zeka Kulübü',
      'adminAvatar': 'assets/images/beykoz.logo.png',
      'timestamp': '6 saat önce',
      'content':
          'Yapay Zeka Kulübü olarak "Makine Öğrenmesi 101" seminerine davetlisiniz! 📊 Tarih: 20 Mart, Yer: Konferans Salonu.',
      'image': null,
      'likes': 92,
      'comments': 25,
      'isLiked': false,
    },
    {
      'id': 6,
      'adminName': 'Yöntek Kulübü',
      'adminAvatar': 'assets/images/beykoz.logo.png',
      'timestamp': '1 gün önce',
      'content':
          '💻 Beykoz Üniversitesi YÖNTEK Kulübü Sunar  🚀\n\nYÖNTEK Kulübü olarak, siber güvenlik ve kariyer yönetimi konularında sizi inanılmaz bir webinara davet ediyoruz 🌟\n\n🔒 Siber Güvenlik Uzmanı Gökay Bekşen ile 6 Ocak Pazartesi günü saat 20.00\'de Google Meets üzerinden buluşuyoruz! Bu harika etkinlikte:\n✨ Siber güvenliğin bilinmeyen dünyasına adım atacak,\n✨ Kariyer yönetimi hakkında altın değerinde tavsiyeler alacak,\n✨ Alanında uzman bir isme birebir sorular sorma fırsatını yakalayacaksınız!\n\n💡 Üstelik etkinliğimiz tamamen ücretsiz ve katılımcılarımıza özel sertifikalı!\n\n📆 Tarih: 6 Ocak Pazartesi\n⏰ Saat: 20.00\n📍 Platform: Google Meets\n📋 Kayıt Formu: https://forms.gle/ApLkGfSdTorZnhgf7\n\n🌐 Teknolojiye meraklıysanız, kariyerinizi daha güvenli ve bilinçli adımlarla şekillendirmek istiyorsanız, bu fırsatı kaçırmayın! 😎\n\n📣 Hadi, formu doldurun ve aramıza katılın. 🌟',
      'image': 'assets/images/yöntek.png',
      'likes': 53,
      'comments': 15,
      'isLiked': true,
    },
  ];

  void _toggleLike(int postId) {
    setState(() {
      int index = posts.indexWhere((post) => post['id'] == postId);
      if (index != -1) {
        posts[index]['isLiked'] = !posts[index]['isLiked'];
        if (posts[index]['isLiked']) {
          posts[index]['likes']++;
        } else {
          posts[index]['likes']--;
        }
      }
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          backgroundColor: themeService.isDarkMode
              ? ThemeService.darkBackgroundColor
              : Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'Üniversite Haberleri',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            backgroundColor: themeService.isDarkMode
                ? ThemeService.darkPrimaryColor
                : primaryColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: posts.length + 1,
              itemBuilder: (context, index) {
                if (index == posts.length) {
                  return const SizedBox(height: 100);
                }
                return _buildPostCard(posts[index]);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: themeService.isDarkMode
                ? ThemeService.darkCardColor
                : cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          (themeService.isDarkMode
                                  ? ThemeService.darkPrimaryColor
                                  : primaryColor)
                              .withOpacity(0.1),
                      backgroundImage: AssetImage(post['adminAvatar']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['adminName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: themeService.isDarkMode
                                  ? ThemeService.darkTextPrimaryColor
                                  : Color(0xFF802629),
                            ),
                          ),
                          Text(
                            post['timestamp'],
                            style: TextStyle(
                              color: themeService.isDarkMode
                                  ? ThemeService.darkTextSecondaryColor
                                  : Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: themeService.isDarkMode
                            ? ThemeService.darkTextSecondaryColor
                            : Colors.grey[600],
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Post Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildPostContent(post['content'], themeService),
              ),

              // Post Image
              if (post['image'] != null)
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      post['image'],
                      fit: BoxFit
                          .fitWidth, // Genişliği doldur, sağ-sol boşluk olmasın
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: themeService.isDarkMode
                            ? ThemeService.darkSurfaceColor
                            : Colors.grey[300],
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: themeService.isDarkMode
                              ? ThemeService.darkTextSecondaryColor
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleLike(post['id']),
                      child: Row(
                        children: [
                          Icon(
                            post['isLiked']
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: post['isLiked']
                                ? Colors.red
                                : (themeService.isDarkMode
                                      ? ThemeService.darkTextSecondaryColor
                                      : Colors.grey[600]),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${post['likes']}',
                            style: TextStyle(
                              color: themeService.isDarkMode
                                  ? ThemeService.darkTextSecondaryColor
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () => _showCommentsBottomSheet(context, post),
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: themeService.isDarkMode
                                ? ThemeService.darkTextSecondaryColor
                                : Colors.grey[600],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${post['comments']}',
                            style: TextStyle(
                              color: themeService.isDarkMode
                                  ? ThemeService.darkTextSecondaryColor
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.share_outlined,
                        color: themeService.isDarkMode
                            ? ThemeService.darkTextSecondaryColor
                            : Colors.grey[600],
                        size: 24,
                      ),
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

  Widget _buildPostContent(String content, ThemeService themeService) {
    // Basit yaklaşım: Link varsa RichText, yoksa normal Text
    if (content.contains('https://')) {
      final List<TextSpan> spans = [];
      final parts = content.split('https://');

      for (int i = 0; i < parts.length; i++) {
        if (i == 0) {
          spans.add(TextSpan(text: parts[i]));
        } else {
          // Link kısmını bul
          final linkPart = parts[i];
          final spaceIndex = linkPart.indexOf(' ');
          final url = spaceIndex != -1
              ? 'https://' + linkPart.substring(0, spaceIndex)
              : 'https://' + linkPart;
          final remainingText = spaceIndex != -1
              ? linkPart.substring(spaceIndex)
              : '';

          // Link span'ı ekle
          spans.add(
            TextSpan(
              text: url,
              style: TextStyle(
                color: themeService.isDarkMode
                    ? Colors.blue[300]
                    : primaryColor,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = () => _launchURL(url),
            ),
          );

          // Kalan metni ekle
          if (remainingText.isNotEmpty) {
            spans.add(TextSpan(text: remainingText));
          }
        }
      }

      return RichText(
        text: TextSpan(
          children: spans,
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: themeService.isDarkMode
                ? ThemeService.darkTextPrimaryColor
                : Colors.grey[800],
          ),
        ),
      );
    } else {
      return Text(
        content,
        style: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: themeService.isDarkMode
              ? ThemeService.darkTextPrimaryColor
              : Colors.grey[800],
        ),
      );
    }
  }

  void _showCommentsBottomSheet(
    BuildContext context,
    Map<String, dynamic> post,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, controller) => Consumer<ThemeService>(
          builder: (context, themeService, child) {
            return Container(
              decoration: BoxDecoration(
                color: themeService.isDarkMode
                    ? ThemeService.darkCardColor
                    : cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: themeService.isDarkMode
                          ? ThemeService.darkSurfaceColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Yorumlar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeService.isDarkMode
                                ? ThemeService.darkPrimaryColor
                                : primaryColor,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${post['comments']} yorum',
                          style: TextStyle(
                            color: themeService.isDarkMode
                                ? ThemeService.darkTextSecondaryColor
                                : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: themeService.isDarkMode
                        ? ThemeService.darkDividerColor
                        : Colors.grey[300],
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      padding: const EdgeInsets.all(20),
                      itemCount: 5,
                      itemBuilder: (context, index) => _buildCommentItem(index),
                    ),
                  ),
                  _buildCommentInput(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCommentItem(int index) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        List<String> users = [
          'Ahmet K.',
          'Ayşe M.',
          'Mehmet S.',
          'Zeynep A.',
          'Can T.',
        ];
        List<String> comments = [
          'Çok faydalı bilgi, teşekkürler!',
          'Ne zaman başvuru yapabiliriz?',
          'Detaylı bilgi için hangi numarayı arayacağız?',
          'Harika bir etkinlik olacak gibi görünüyor 👍',
          'Bu konuda daha fazla bilgi alabilir miyiz?',
        ];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor:
                    (themeService.isDarkMode
                            ? ThemeService.darkPrimaryColor
                            : primaryColor)
                        .withOpacity(0.1),
                child: Text(
                  users[index][0],
                  style: TextStyle(
                    color: themeService.isDarkMode
                        ? ThemeService.darkPrimaryColor
                        : primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      users[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: themeService.isDarkMode
                            ? ThemeService.darkPrimaryColor
                            : primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comments[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: themeService.isDarkMode
                            ? ThemeService.darkTextPrimaryColor
                            : Colors.grey[700],
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${index + 1} saat önce',
                      style: TextStyle(
                        fontSize: 12,
                        color: themeService.isDarkMode
                            ? ThemeService.darkTextSecondaryColor
                            : Colors.grey[500],
                      ),
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

  Widget _buildCommentInput() {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeService.isDarkMode
                ? ThemeService.darkCardColor
                : cardColor,
            border: Border(
              top: BorderSide(
                color: themeService.isDarkMode
                    ? ThemeService.darkDividerColor
                    : Colors.grey[200]!,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      (themeService.isDarkMode
                              ? ThemeService.darkPrimaryColor
                              : primaryColor)
                          .withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: themeService.isDarkMode
                        ? ThemeService.darkPrimaryColor
                        : primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      color: themeService.isDarkMode
                          ? ThemeService.darkTextPrimaryColor
                          : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Bir yorum yazın...',
                      hintStyle: TextStyle(
                        color: themeService.isDarkMode
                            ? ThemeService.darkTextSecondaryColor
                            : Colors.grey[500],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: themeService.isDarkMode
                              ? ThemeService.darkDividerColor
                              : Colors.grey[300]!,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF802629), Color(0xFFB2453C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () {},
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
