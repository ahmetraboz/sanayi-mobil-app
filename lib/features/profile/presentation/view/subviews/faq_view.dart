import 'package:flutter/material.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// Sıkça Sorulan Sorular (FAQ) Ekranı
class FaqView extends StatelessWidget {
  const FaqView({super.key});

  final List<Map<String, String>> _faqs = const [
    {
      'q': 'Randevumu nasıl iptal edebilirim?',
      'a': 'Profil > Hizmetlerim sekmesinden aktif randevunuzu seçerek randevu saatinden 2 saat öncesine kadar ücretsiz iptal edebilirsiniz.',
    },
    {
      'q': 'Ödeme ne zaman ve nasıl tahsil edilir?',
      'a': 'Randevu oluştururken girdiğiniz kredi kartınızdan 3D Secure ile güvenli ön provizyon alınır. Hizmet tamamlandığında usta onayıyla işlem kesinleşir.',
    },
    {
      'q': 'SanayiGO Garanti Kapsamı neleri içerir?',
      'a': 'Platformumuz üzerinden yapılan tüm periyodik bakım ve parça değişimleri 1 yıl veya 20.000 KM parça ve işçilik garantisi altındadır.',
    },
    {
      'q': 'Serviste ek masraf çıkarsa ne olur?',
      'a': 'Usta aracınızı incelediğinde ek parça ihtiyacı tespit ederse uygulama üzerinden onayınıza sunar. Sizin onayınız olmadan hiçbir işlem yapılmaz.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Sıkça Sorulan Sorular', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF1F5F9), height: 1),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.p20),
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          final f = _faqs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.r16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: AppDimensions.cardShadow,
            ),
            child: ExpansionTile(
              title: Text(f['q']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                Text(f['a']!, style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4)),
              ],
            ),
          );
        },
      ),
    );
  }
}
