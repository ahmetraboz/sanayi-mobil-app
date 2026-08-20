import 'package:flutter/material.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'profile_menu_item.dart';

/// Gruplanmış Profil Menü Kartı
class ProfileMenuGroup extends StatelessWidget {
  final List<ProfileMenuItem> items;

  const ProfileMenuGroup({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.r20),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: AppDimensions.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.r20),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            indent: 72,
            endIndent: 16,
            color: Color(0xFFF1F5F9),
          ),
          itemBuilder: (context, index) => items[index],
        ),
      ),
    );
  }
}
