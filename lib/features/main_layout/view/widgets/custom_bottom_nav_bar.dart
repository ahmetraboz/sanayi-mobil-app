import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/features/main_layout/cubit/navigation_cubit.dart';

/// Yüzen (Floating) iPhone Tarzı Alt Gezinme Çubuğu
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.p16,
        right: AppDimensions.p16,
        bottom: bottomPadding > 0 ? bottomPadding + 4 : AppDimensions.p16,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Yüzen Kapsül Gövde (Buzlu Cam / Frosted Glass Efekti)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.r32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(AppDimensions.r32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.12),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Sol Sekmeler
                    _FloatingNavBarItem(
                      icon: LucideIcons.home,
                      label: 'Anasayfa',
                      isSelected: activeTab == BottomNavTab.home,
                      onTap: () => onTabSelected(BottomNavTab.home),
                    ),
                    _FloatingNavBarItem(
                      icon: LucideIcons.car,
                      label: 'Garaj',
                      isSelected: activeTab == BottomNavTab.garage,
                      onTap: () => onTabSelected(BottomNavTab.garage),
                    ),

                    // Ortadaki Yüzen Buton İçin Boşluk
                    const SizedBox(width: 54),

                    // Sağ Sekmeler
                    _FloatingNavBarItem(
                      icon: LucideIcons.gift,
                      label: 'Kampanya',
                      isSelected: activeTab == BottomNavTab.campaign,
                      onTap: () => onTabSelected(BottomNavTab.campaign),
                    ),
                    _FloatingNavBarItem(
                      icon: LucideIcons.headphones,
                      label: 'Destek',
                      isSelected: activeTab == BottomNavTab.support,
                      onTap: () => onTabSelected(BottomNavTab.support),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Ortadaki Çıkıntılı Yüzen QR / Aksiyon Butonu
          Positioned(
            top: -22,
            child: GestureDetector(
              onTap: onCenterActionTap,
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF22D3EE), // Parlak Turkuaz Cyan
                      Color(0xFF0284C7), // Okyanus Mavisi
                    ],
                  ),
                  border: Border.all(color: Colors.white, width: 3.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.45),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    LucideIcons.scan,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingNavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FloatingNavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final inactiveColor = AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primary.withValues(alpha: 0.1),
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.r20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                size: 21,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
