import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/features/notifications/presentation/view/notification_view.dart';
import 'package:sanayi_mobil_app/features/profile/presentation/view/profile_view.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Profesyonel Üst Başlık (Ana Sayfa Logo + Sekme Başlıkları için Tutarlı Tasarım)
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final Widget? trailingAction;

  const AppHeader({
    super.key,
    this.title,
    this.onNotificationTap,
    this.onProfileTap,
    this.trailingAction,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Sol Taraf: Eğer title varsa Başlık Metni, yoksa SanayiGO Logo & İsim
            if (title != null)
              Text(
                title!,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
              )
            else
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppDimensions.r12),
                      gradient: AppColors.turquoiseGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.wrench,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.p12),
                  RichText(
                    text: const TextSpan(
                      text: 'SANAYİ',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'GO',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            // Sağ Taraf: Bildirim & Profil Butonları veya Özel Aksiyon
            Row(
              children: [
                if (trailingAction != null) ...[
                  trailingAction!,
                  const SizedBox(width: AppDimensions.p8),
                ],
                _HeaderIconButton(
                  icon: LucideIcons.bell,
                  hasBadge: true,
                  onTap: onNotificationTap ??
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationView(),
                          ),
                        );
                      },
                ),
                const SizedBox(width: AppDimensions.p12),
                _HeaderIconButton(
                  icon: LucideIcons.user,
                  onTap: onProfileTap ??
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileView(),
                          ),
                        );
                      },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final bool hasBadge;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    this.hasBadge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.rFull),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
          boxShadow: AppDimensions.cardShadow,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: AppColors.textPrimary,
            ),
            if (hasBadge)
              Positioned(
                top: 9,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
