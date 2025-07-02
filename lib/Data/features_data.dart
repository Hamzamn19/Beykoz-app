import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeaturesData {
  static final List<Map<String, dynamic>> dersIslemleriFeatures = [
    {
      'label': 'Slotlar',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/ogrenci/slot',
      'icon': FontAwesomeIcons.calendarAlt,
    },
    {
      'label': 'Ders Seçme',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/derssecme/ogrindex',
      'icon': FontAwesomeIcons.tasks,
    },
    {
      'label': 'Uygulamalı Eğitim Başvurusu',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/staj/basvuruliste',
      'icon': FontAwesomeIcons.briefcase,
    },
    {
      'label': 'Sınav İtirazları',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/sinavitiraz/liste',
      'icon': FontAwesomeIcons.gavel,
    },
    {
      'label': 'Tek Ders Sınavı Başvurusu',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/derssecme/tekderssinavi',
      'icon': FontAwesomeIcons.fileSignature,
    },
  ];

  static final List<Map<String, dynamic>> belgelerFeatures = [
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
      'url': 'https://ois.beykoz.edu.tr/hazirlik/hazirliksinav/ogrpreptranskript',
      'icon': FontAwesomeIcons.bookReader,
    },
    {
      'label': 'Ders Onay Belgesi',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/dersdanismanonay',
      'icon': FontAwesomeIcons.stamp,
    },
    {
      'label': 'Kesin Kayıt Belgesi',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/kesinkayitbelgesi',
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
    {
      'label': 'Sınav Sonuçları',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/ogrsinavsonuc',
      'icon': FontAwesomeIcons.poll,
    },
  ];

  static final List<Map<String, dynamic>> digerIslemlerFeatures = [
    {
      'label': 'Parola Değiştirme',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/ogrenci/paroladegistirme',
      'icon': FontAwesomeIcons.key,
    },
    {
      'label': 'GNO Hesaplama',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/belge/ogrtranskripthesap',
      'icon': FontAwesomeIcons.calculator,
    },
    {
      'label': 'PDR Başvuru',
      'url': 'https://ois.beykoz.edu.tr/crm/pdr/basvuru',
      'icon': FontAwesomeIcons.brain,
    },
    {
      'label': 'Danışman Randevu',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/ogrencirandevu',
      'icon': FontAwesomeIcons.handshake,
    },
    {
      'label': 'Engel Bilgileriniz',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/engelbilgileri/duzenle',
      'icon': FontAwesomeIcons.universalAccess,
    },
    {
      'label': 'İlişki Kesme Talebi',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/iliskikesme/beyan',
      'icon': FontAwesomeIcons.userSlash,
    },
    {
      'label': 'Tez/Proje Konu Seçme',
      'url': 'https://ois.beykoz.edu.tr',
      'icon': FontAwesomeIcons.lightbulb,
    },
    {
      'label': 'Kulüp Seç. Oy Kullan',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/kulup/secimpuanduzenle',
      'icon': FontAwesomeIcons.voteYea,
    },
    {
      'label': 'Kulüp Üyelik Formu',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/kulup/ogrencikulupbasvuru',
      'icon': FontAwesomeIcons.userPlus,
    },
    {
      'label': 'Kulüp Üyelik Kontrol',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/ogrencirandevu',
      'icon': FontAwesomeIcons.userCheck,
    },
    {
      'label': 'Öğr. Kulüb. Başkan Adaylık Baş.',
      'url': 'https://ois.beykoz.edu.tr/ogrenciler/kulup/secimliste',
      'icon': FontAwesomeIcons.userTie,
    },
  ];

  // Tüm özellikleri tek bir listede birleştiren yardımcı metot
  static List<Map<String, dynamic>> getAllFeatures() {
    return [
      ...dersIslemleriFeatures,
      ...belgelerFeatures,
      ...digerIslemlerFeatures,
    ];
  }
}