import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../home/data/models/campaign_banner_model.dart';
import 'campaign_detail_sheet.dart';

/// Kampanyalar Görünümü
class CampaignView extends StatelessWidget {
  const CampaignView({super.key});

  // Kampanya listesi - gerçek uygulamada bir repository'den gelecek
  static const List<CampaignBannerModel> _campaigns = [
    CampaignBannerModel(
      id: 'camp_1',
      title: "5'li Yıkama Paketi & 1.000 TL Yakıt",
      subtitle: "Anlaşmalı tüm istasyon ve oto kuaförlerde geçerli dev paket!",
      discountCode: 'İND1000',
      priceHighlight: '2.500 TL',
      giftHighlight: '1.000 TL Yakıt',
      badgeText: '5 AY GEÇERLİ',
      imageUrl: 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?auto=format&fit=crop&w=1200&q=80',
      detailTitle: "5'li Yıkama Paketi",
      detailDescription:
          'Nasıl Kullanılır?\n\nAnlaşmalı tüm istasyon ve oto kuaförlerde geçerli olan bu dev paketi SanayiGO üzerinden kolayca kullanabilirsiniz.',
      detailSteps: [
        'SanayiGO uygulamasını açın.',
        'Araç Yıkama sekmesine gidin.',
        'Yakınınızdaki anlaşmalı istasyonu seçin.',
        'Ödeme sırasında "İND1000" kodunu girin.',
        '5 yıkama hakkınızı dilediğiniz zaman kullanın.',
        '1.000 TL yakıt hediyeniz hesabınıza otomatik yüklenir.',
      ],
      ctaText: 'Hizmet Al',
    ),
    CampaignBannerModel(
      id: 'camp_2',
      title: 'Yetkili Sanayi Bakımında %30 İndirim',
      subtitle: 'Orijinal parça ve işçilik garantili periyodik bakım fırsatı.',
      discountCode: 'BAKIM30',
      priceHighlight: '%30 İNDİRİM',
      giftHighlight: 'Ücretsiz Check-Up',
      badgeText: 'SINIRLI SÜRE',
      imageUrl: 'https://images.unsplash.com/photo-1486006920555-c77dce18193b?auto=format&fit=crop&w=1200&q=80',
      detailTitle: 'Periyodik Bakım İndirimi',
      detailDescription:
          'Nasıl Kullanılır?\n\nOrijinal parça ve işçilik garantili periyodik bakımı yetkili sanayi ustalarına yaptırın, %30 indirim kazanın.',
      detailSteps: [
        'SanayiGO uygulamasını açın.',
        'Bakım & Servis sekmesine gidin.',
        'Yakınınızdaki yetkili servisi seçin.',
        'Randevu oluşturun ve "BAKIM30" kodunu ekleyin.',
        'Servis sonrası ücretsiz araç check-up raporunuzu alın.',
        'Fatura tutarınızdan %30 indirim otomatik düşülür.',
      ],
      ctaText: 'Randevu Al',
    ),
    CampaignBannerModel(
      id: 'camp_3',
      title: 'Lastik Değişimi & 1 Sezon Otel',
      subtitle: '4 adet lastik değişiminde ücretsiz balans ve depolama imkanı.',
      discountCode: 'LASTIK2026',
      priceHighlight: 'ÜCRETSİZ OTEL',
      giftHighlight: 'Balans Hediyeli',
      badgeText: 'YENİ SEZON',
      imageUrl: 'https://images.unsplash.com/photo-1578844251758-2f71da64c96f?auto=format&fit=crop&w=1200&q=80',
      detailTitle: 'Lastik Değişimi & Otel',
      detailDescription:
          'Nasıl Kullanılır?\n\n4 adet lastik değişiminde ücretsiz balans ve 1 sezon lastik oteli hizmetinden yararlanın.',
      detailSteps: [
        'SanayiGO uygulamasını açın.',
        'Lastik Hizmetleri sekmesine gidin.',
        'Anlaşmalı lastikçiyi seçin ve randevu alın.',
        '"LASTIK2026" kodunu ödeme sırasında uygulayın.',
        '4 lastik değişiminde balans işlemi ücretsiz yapılır.',
        'Lastikleriniz sezon boyunca güvende saklanır.',
      ],
      ctaText: 'Hizmet Al',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.p20,
          AppDimensions.p16,
          AppDimensions.p20,
          120, // Floating Bottom Nav Bar için güvenli alan
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tüm Kampanyalar',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'SanayiGO üyelerine özel indirim ve fırsatları keşfedin.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ..._campaigns.map((campaign) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _CampaignCard(campaign: campaign),
                )),
          ],
        ),
      ),
    );
  }
}

/// Tıklanabilir Kampanya Kartı
class _CampaignCard extends StatelessWidget {
  final CampaignBannerModel campaign;

  const _CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CampaignDetailSheet.show(context, campaign),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.r20),
          boxShadow: AppDimensions.cardShadow,
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kampanya görseli
            SizedBox(
              height: 140,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    campaign.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFFE2E8F0),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF0F172A).withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badge
                  if (campaign.badgeText != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppDimensions.r8),
                        ),
                        child: Text(
                          campaign.badgeText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  // Detay görme ok ikonu
                  const Positioned(
                    right: 12,
                    bottom: 12,
                    child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),

            // Alt içerik bölümü
            Padding(
              padding: const EdgeInsets.all(AppDimensions.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    campaign.subtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  if (campaign.discountCode != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.confirmation_number_outlined, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'KOD: ${campaign.discountCode}',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Detayları Gör →',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
