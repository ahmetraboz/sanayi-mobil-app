import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/features/profile/data/models/user_profile_model.dart';

/// Profil Üst Bilgi Başlığı (Avatar, İsim, E-posta, Referans Kodu)
class ProfileHeaderCard extends StatelessWidget {
  final UserProfileModel user;

  const ProfileHeaderCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        // Profil Yuvarlak Avatarı
        Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              user.initials,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Kullanıcı Adı
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),

        // E-posta
        Text(
          user.email,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),

        // Referans Kodu & Bakiye Kapsülü
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.rFull),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.referralCode,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                LucideIcons.share2,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              Container(
                width: 1,
                height: 14,
                color: AppColors.divider,
              ),
              const SizedBox(width: 10),
              Text(
                '${user.balance.toStringAsFixed(0)}₺',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
