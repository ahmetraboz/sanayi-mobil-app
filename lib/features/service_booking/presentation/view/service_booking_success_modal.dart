import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/core/utils/turkish_number_helper.dart';

/// Randevu & Ödeme Başarılı Onay Modalı
class ServiceBookingSuccessModal extends StatelessWidget {
  final String serviceTitle;
  final String vehiclePlate;
  final String providerName;
  final String appointmentDate;
  final double totalCost;

  const ServiceBookingSuccessModal({
    super.key,
    required this.serviceTitle,
    required this.vehiclePlate,
    required this.providerName,
    required this.appointmentDate,
    required this.totalCost,
  });

  static void show(
    BuildContext context, {
    required String serviceTitle,
    required String vehiclePlate,
    required String providerName,
    required String appointmentDate,
    required double totalCost,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ServiceBookingSuccessModal(
        serviceTitle: serviceTitle,
        vehiclePlate: vehiclePlate,
        providerName: providerName,
        appointmentDate: appointmentDate,
        totalCost: totalCost,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 24 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Yeşil Onay Rozeti
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.checkCheck, color: AppColors.success, size: 36),
          ),
          const SizedBox(height: 18),

          const Text(
            'Randevunuz Onaylandı!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ödemeniz başarıyla alındı ve servis noktasına randevu bilgileriniz iletildi.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),

          const SizedBox(height: 20),

          // Özet Bilgi Kartı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.p16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(AppDimensions.r16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildRow('Hizmet', serviceTitle),
                const Divider(height: 16, color: Color(0xFFE2E8F0)),
                _buildRow('Araç', vehiclePlate),
                const Divider(height: 16, color: Color(0xFFE2E8F0)),
                _buildRow('Yetkili Bayi', providerName),
                const Divider(height: 16, color: Color(0xFFE2E8F0)),
                _buildRow('Randevu Zamanı', appointmentDate),
                const Divider(height: 16, color: Color(0xFFE2E8F0)),
                _buildRow('Ödenen Tutar', '${TurkishNumberHelper.formatWithDot(totalCost.toInt())} ₺', isBold: true),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Garajıma Git / Tamam Butonu
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r16)),
                elevation: 0,
              ),
              onPressed: () {
                // Ana Sayfaya veya Garajıma dön
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                'Harika, Ana Sayfaya Dön',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14 : 12.5,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: isBold ? AppColors.primary : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
