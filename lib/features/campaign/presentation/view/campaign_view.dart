import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_header.dart';

/// Kampanyalar Görünümü
class CampaignView extends StatelessWidget {
  const CampaignView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.p20),
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

            _buildOfferCard(
              title: "5'li Yıkama Paketi & 1.000 TL Yakıt",
              description: 'Anlaşmalı tüm istasyon ve oto kuaförlerde geçerli dev paket!',
              code: 'İND1000',
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            _buildOfferCard(
              title: 'Yetkili Sanayi Bakımında %30 İndirim',
              description: 'Orijinal parça ve işçilik garantili periyodik bakım fırsatı.',
              code: 'BAKIM30',
              color: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            _buildOfferCard(
              title: 'Lastik Değişimi & 1 Sezon Otel',
              description: '4 adet lastik değişiminde ücretsiz balans ve depolama imkanı.',
              code: 'LASTIK2026',
              color: const Color(0xFF0D9488),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard({
    required String title,
    required String description,
    required String code,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.r20),
        boxShadow: AppDimensions.cardShadow,
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppDimensions.r8),
                ),
                child: const Text(
                  'ÖZEL FIRSAT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'KOD: $code',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
