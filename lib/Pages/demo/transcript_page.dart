// file: lib/Pages/transcript_page.dart

import 'package:flutter/material.dart';

// --- VERİ MODELLERİ (TÜRKÇE) ---
class Ders {
  final String kod;
  final String ad;
  final String kredi;
  final String harfNotu;
  final double puan;

  Ders({
    required this.kod,
    required this.ad,
    required this.kredi,
    required this.harfNotu,
    required this.puan,
  });
}

class Donem {
  final String baslik;
  final List<Ders> dersler;
  final double donemOrtalamasi;
  final double genelOrtalama;

  Donem({
    required this.baslik,
    required this.dersler,
    required this.donemOrtalamasi,
    required this.genelOrtalama,
  });
}

class OgrenciBilgileri {
  final String tcKimlikNo;
  final String ogrenciNo;
  final String ad;
  final String soyad;
  final String fakulte;
  final String bolum;

  OgrenciBilgileri({
    required this.tcKimlikNo,
    required this.ogrenciNo,
    required this.ad,
    required this.soyad,
    required this.fakulte,
    required this.bolum,
  });
}

class TranskriptEkrani extends StatelessWidget {
  const TranskriptEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek verileri burada oluşturuyoruz.
    final ogrenci = OgrenciBilgileri(
      tcKimlikNo: '1111111111',
      ogrenciNo: '11111111',
      ad: 'ayşe',
      soyad: 'yılmaz',
      fakulte: 'Mühendislik ve Mimarlık Fakültesi',
      bolum: 'Bilgisayar Mühendisliği',
    );

    final donemler = [
      Donem(
        baslik: '1. Semester: 2024-2025 Fall',
        donemOrtalamasi: 3.17,
        genelOrtalama: 3.17,
        dersler: [
          Ders(
            kod: '60031YEEEOZ-CDP2021',
            ad: 'Competency Development Program I (Career Planning)',
            kredi: '1|1.0',
            harfNotu: 'BI',
            puan: 0.00,
          ),
          Ders(
            kod: '60231YEEEOZ-ENG1021',
            ad: 'Advanced English I',
            kredi: '4|4.0',
            harfNotu: 'CC',
            puan: 8.00,
          ),
          Ders(
            kod: '60533TAEOZ-PHY3031',
            ad: 'Physics I',
            kredi: '3|5.0',
            harfNotu: 'BB',
            puan: 15.00,
          ),
          Ders(
            kod: '60533TAEOZ-PHY3261',
            ad: 'Physics Laboratory I',
            kredi: '1|3.0',
            harfNotu: 'BB',
            puan: 9.00,
          ),
          Ders(
            kod: '60541TAEOZ-MTH3031',
            ad: 'Calculus I',
            kredi: '3|5.0',
            harfNotu: 'BB',
            puan: 15.00,
          ),
          Ders(
            kod: '60611TAEOZ-ICT3221',
            ad: 'Information and Communication Technologies',
            kredi: '3|6.0',
            harfNotu: 'BA',
            puan: 21.00,
          ),
          Ders(
            kod: '60613TAEOZ-CMP3231',
            ad: 'Introduction to Programming',
            kredi: '3|6.0',
            harfNotu: 'AA',
            puan: 24.00,
          ),
        ],
      ),
      Donem(
        baslik: '2. Semester: 2024-2025 Spring',
        donemOrtalamasi: 2.88,
        genelOrtalama: 3.03,
        dersler: [
          Ders(
            kod: '60231YEEEOZ-ENG1042',
            ad: 'Advanced English II',
            kredi: '4|4.0',
            harfNotu: 'BA',
            puan: 14.00,
          ),
          Ders(
            kod: '60413YEEOS-COM2012',
            ad: 'E-Commerce',
            kredi: '2|3.0',
            harfNotu: 'BB',
            puan: 9.00,
          ),
          Ders(
            kod: '60533TAEOZ-PHY3072',
            ad: 'Physics II',
            kredi: '3|5.0',
            harfNotu: 'BB',
            puan: 15.00,
          ),
          Ders(
            kod: '60533TAEOZ-PHY3272',
            ad: 'Physics Laboratory II',
            kredi: '1|3.0',
            harfNotu: 'CB',
            puan: 7.50,
          ),
          Ders(
            kod: '60541TAEOZ-MTH3042',
            ad: 'Calculus II',
            kredi: '3|5.0',
            harfNotu: 'CC',
            puan: 10.00,
          ),
          Ders(
            kod: '60610PREOZ-CMEU202',
            ad: 'Engineering Project I (Computer Engineering)',
            kredi: '3|4.0',
            harfNotu: 'AA',
            puan: 16.00,
          ),
          Ders(
            kod: '60613TAEOZ-CMP3252',
            ad: 'Object-Oriented Programming',
            kredi: '3|6.0',
            harfNotu: 'CB',
            puan: 15.00,
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Transkript'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildUstBilgi(context),
          const SizedBox(height: 24),
          // CGPA and Total Credits updated to match the image
          _buildGenelOrtalamaKarti('3.03', '60'),
          const SizedBox(height: 24),
          _buildOgrenciBilgileri(ogrenci),
          const SizedBox(height: 24),
          Text(
            'Dönem Detayları',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(thickness: 1.5),
          const SizedBox(height: 8),
          ...donemler.map((donem) => _buildDonemKarti(context, donem)).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // PDF indirme fonksiyonunu buraya ekleyebilirsiniz
        },
        label: const Text('PDF Olarak İndir'),
        icon: const Icon(Icons.download),
      ),
    );
  }

  Widget _buildUstBilgi(BuildContext context) {
    return Row(
      children: [
        // asset'lerde logo olduğundan emin olun
        // Image.asset('assets/images/logo.png', width: 60, height: 60),
        const Icon(Icons.school, size: 60), // Placeholder icon
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BEYKOZ ÜNİVERSİTESİ',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Öğrenci İşleri Daire Başkanlığı',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenelOrtalamaKarti(String gpa, String kredi) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text(
                  'GNO',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  gpa,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40, child: VerticalDivider()),
            Column(
              children: [
                const Text(
                  'Toplam AKTS',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  kredi,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOgrenciBilgileri(OgrenciBilgileri ogrenci) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bilgiSatiri('Öğrenci No', ogrenci.ogrenciNo),
        _bilgiSatiri('Fakülte', ogrenci.fakulte),
        _bilgiSatiri('Bölüm', ogrenci.bolum),
      ],
    );
  }

  Widget _bilgiSatiri(String baslik, String deger) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, color: Colors.black87),
          children: [
            TextSpan(
              text: '$baslik: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: deger),
          ],
        ),
      ),
    );
  }

  Widget _buildDonemKarti(BuildContext context, Donem donem) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(
          donem.baslik,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          'Dönem Ortalaması (GPA): ${donem.donemOrtalamasi.toStringAsFixed(2)}',
        ),
        leading: Icon(
          Icons.school_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        children: donem.dersler.map((ders) => _buildDersSatiri(ders)).toList(),
      ),
    );
  }

  Widget _buildDersSatiri(Ders ders) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(ders.ad),
      subtitle: Text('Kod: ${ders.kod} - Kredi: ${ders.kredi}'),
      trailing: CircleAvatar(
        radius: 22,
        backgroundColor: _getNotRengi(ders.harfNotu),
        child: Text(
          ders.harfNotu,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getNotRengi(String not) {
    switch (not) {
      case 'AA':
      case 'BA':
        return Colors.green.shade600;
      case 'BB':
      case 'CB':
        return Colors.blue.shade600;
      case 'CC':
      case 'DC':
        return Colors.orange.shade600;
      case 'FF':
      case 'FD':
        return Colors.red.shade600;
      default:
        // BI, etc.
        return Colors.grey.shade600;
    }
  }
}
