import 'package:flutter/material.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/core/constants/app_strings.dart';
import 'package:sanayi_mobil_app/features/home/data/models/service_category_model.dart';
import 'service_card_item.dart';

/// Hizmetler Grid Bileşeni
class ServicesGridWidget extends StatelessWidget {
  final List<ServiceCategoryModel> services;
  final Function(ServiceCategoryModel) onServiceSelected;

  const ServicesGridWidget({
    super.key,
    required this.services,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hizmetler Başlığı
          const Text(
            AppStrings.servicesTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: AppDimensions.p16),

          // 4 Kolonlu Grid Yapısı
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              final service = services[index];
              return ServiceCardItem(
                service: service,
                onTap: () => onServiceSelected(service),
              );
            },
          ),
        ],
      ),
    );
  }
}
