import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // Örnek post verileri
  List<Map<String, dynamic>> posts = [
    {
      'id': 1,
      'adminName': 'Öğrenci İşleri',
      'adminAvatar': 'assets/admin1.jpg',
      'timestamp': '2 saat önce',
      'content':
          'Bahar dönemi kayıt işlemleri 15 Mart tarihinde başlayacaktır. Detaylı bilgi için öğrenci işleri birimine başvurunuz.',
      'image': 'assets/kayit.jpg',
      'likes': 45,
      'comments': 12,
      'isLiked': false,
    },
    {
      'id': 2,
      'adminName': 'Sosyal Aktiviteler',
      'adminAvatar': 'assets/admin2.jpg',
      'timestamp': '5 saat önce',
      'content':
          'Üniversitemiz spor festivaline tüm öğrencilerimizi davet ediyoruz! 🎉 Kayıtlar başladı.',
      'image': 'assets/festival.jpg',
      'likes': 128,
      'comments': 34,
      'isLiked': true,
    },
    {
      'id': 3,
      'adminName': 'Akademik Koordinatörlük',
      'adminAvatar': 'assets/admin3.jpg',
      'timestamp': '1 gün önce',
      'content':
          'Final sınavları programı açıklandı. Öğrenci bilgi sisteminden kontrol edebilirsiniz.',
      'image': null,
      'likes': 89,
      'comments': 23,
      'isLiked': false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Üniversite Haberleri',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF802629),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Yenileme işlemi
          await Future.delayed(Duration(seconds: 1));
        },
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return _buildPostCard(posts[index]);
          },
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFE8C1C2),
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: Color(0xFF802629),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['adminName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        post['timestamp'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Post Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post['content'],
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.grey[800],
              ),
            ),
          ),

          // Post Image
          if (post['image'] != null)
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                ),
              ),
            ),

          // Action Buttons
          Padding(
            padding: EdgeInsets.all(16),
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
                        color: post['isLiked'] ? Colors.red : Colors.grey[600],
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${post['likes']}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24),
                GestureDetector(
                  onTap: () => _showCommentsBottomSheet(context, post),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${post['comments']}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.share_outlined,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Yorumlar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${post['comments']} yorum',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: EdgeInsets.all(20),
                  itemCount: 5, // Örnek yorum sayısı
                  itemBuilder: (context, index) => _buildCommentItem(index),
                ),
              ),
              _buildCommentInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentItem(int index) {
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
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFE8C1C2),
            child: Text(
              users[index][0],
              style: TextStyle(
                color: Color(0xFF802629),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  users[index],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  comments[index],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${index + 1} saat önce',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFE8C1C2),
              child: Icon(Icons.person, color: Color(0xFF802629), size: 18),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Bir yorum yazın...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF802629),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
