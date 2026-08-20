import 'package:flutter/material.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// Profil Menü Satırı (Anında Tepki Veren iOS Tarzı Dokunma)
class ProfileMenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<ProfileMenuItem> createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<ProfileMenuItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _isPressed ? const Color(0xFFF1F5F9) : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.p16,
          vertical: 14,
        ),
        child: Row(
          children: [
            // İkon Kutusu
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _isPressed ? const Color(0xFFE2E8F0) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(AppDimensions.r12),
              ),
              child: Icon(
                widget.icon,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 14),

            // Başlık & Açıklama
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Sağ Ok İkonu
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD5E1),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
