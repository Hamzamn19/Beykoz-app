import 'package:flutter/material.dart';

class AllFeaturesSheet extends StatelessWidget {
  const AllFeaturesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      // başlangıçta ekranın %60'ını kaplamasını sağlar
      initialChildSize: 0.6,
      // minimum %50'ye kadar küçültülebilir, daha aşağı inmez
      minChildSize: 0.50,
      // maksimum tam ekran kaplar
      maxChildSize: 1.0,
      // true yaparak ekranı tamamen doldurmasını sağlıyoruz.
      expand: true,
      // YENİ: Sıçrama efektini aktif eder.
      snap: true,
      // YENİ: Sadece bu boyutlarda durmasına izin verir.
      // Kullanıcı sürükleyip bıraktığında, en yakın değere sıçrar.
      snapSizes: const [0.6, 1.0],
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // --- Sürükleme Çubuğu ---
              Container(
                width: 80,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF802629).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // --- Sayfanın Geri Kalan İçeriği ---
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'TÜMÜ',
                          style: TextStyle(
                            color: Color(0xFF802629),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // İçeriğin kaydırılabilir olduğunu görmek için buraya birkaç öğe ekleyebilirsin
                    // Örnek:
                    // ... List.generate(30, (index) => ListTile(title: Text('Öğe ${index + 1}')))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}