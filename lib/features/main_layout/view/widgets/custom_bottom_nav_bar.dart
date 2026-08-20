import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../cubit/navigation_cubit.dart';

/// Rabam Tarzı Özel Çıkıntılı Alt Gezinme Çubuğu
class CustomBottomNavBar extends StatelessWidget {
  final BottomNavTab activeTab;
  final Function(BottomNavTab) onTabSelected;
  final VoidCallback onCenterActionTap;

  const CustomBottomNavBar({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
    required this.onCenterActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // Alt Bar Gövdesi
        Container(
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Sol Sekmeler
              _NavBarItem(
                icon: LucideIcons.home,
                label: 'Anasayfa',
                isSelected: activeTab == BottomNavTab.home,
                onTap: () => onTabSelected(BottomNavTab.home),
              ),
              _NavBarItem(
                icon: LucideIcons.car,
                label: 'Garaj',
                isSelected: activeTab == BottomNavTab.garage,
                onTap: () => onTabSelected(BottomNavTab.garage),
              ),

              // Ortadaki Boşluk (Yuvarlak Buton İçin)
              const SizedBox(width: 56),

              // Sağ Sekmeler
              _NavBarItem(
                icon: LucideIcons.gift,
                label: 'Kampanya',
                isSelected: activeTab == BottomNavTab.campaign,
                onTap: () => onTabSelected(BottomNavTab.campaign),
              ),
              _NavBarItem(
                icon: LucideIcons.headphones,
                label: 'Destek',
                isSelected: activeTab == BottomNavTab.support,
                onTap: () => onTabSelected(BottomNavTab.support),
              ),
            ],
          ),
        ),

        // Ortadaki Çıkıntılı Mavi/Turkuaz Aksiyon Butonu
        Positioned(
          top: -24,
          child: GestureDetector(
            onTap: onCenterActionTap,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF38BDF8),
                    Color(0xFF0284C7),
                  ],
                ),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.scan,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.secondary : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.r12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
