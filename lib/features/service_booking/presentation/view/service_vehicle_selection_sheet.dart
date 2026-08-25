import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/core/di/service_locator.dart';
import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_model.dart';
import 'package:sanayi_mobil_app/features/garage/presentation/cubit/garage_cubit.dart';
import 'package:sanayi_mobil_app/features/garage/presentation/cubit/garage_state.dart';
import 'package:sanayi_mobil_app/features/garage/presentation/view/add_vehicle_view.dart';
import 'service_providers_view.dart';

/// Hizmet Alınacak Aracı Seçme Modalı
class ServiceVehicleSelectionSheet extends StatelessWidget {
  final String serviceTitle;

  const ServiceVehicleSelectionSheet({
    super.key,
    required this.serviceTitle,
  });

  static Future<void> show(BuildContext context, {required String serviceTitle}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: getIt<GarageCubit>()..loadVehicles(),
        child: ServiceVehicleSelectionSheet(serviceTitle: serviceTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),

          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Başlık
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hizmet Alınacak Aracı Seçin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      serviceTitle.replaceAll('\n', ' '),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 20, color: Color(0xFFE2E8F0)),

          // Araç Listesi
          Flexible(
            child: BlocBuilder<GarageCubit, GarageState>(
              builder: (context, state) {
                final vehicles = state.vehicles;

                if (vehicles.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.car, size: 48, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 12),
                        const Text(
                          'Kayıtlı Aracınız Bulunmuyor',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Hizmet alabilmek için lütfen önce garajınıza araç ekleyin.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<GarageCubit>(),
                                  child: const AddVehicleView(),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Yeni Araç Ekle'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: vehicles.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == vehicles.length) {
                      // Yeni Araç Ekle Butonu
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<GarageCubit>(),
                                child: const AddVehicleView(),
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(AppDimensions.r16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppDimensions.r16),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), style: BorderStyle.solid),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline, color: AppColors.primary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Farklı Bir Araç Ekle',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final vehicle = vehicles[index];
                    return _VehicleSelectionCard(
                      vehicle: vehicle,
                      onTap: () {
                        Navigator.pop(context); // modalı kapat
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceProvidersView(
                              serviceTitle: serviceTitle.replaceAll('\n', ' '),
                              selectedVehicle: vehicle,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _VehicleSelectionCard extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback onTap;

  const _VehicleSelectionCard({
    required this.vehicle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    IconData typeIcon = LucideIcons.car;
    if (vehicle.vehicleType == 'motorcycle') typeIcon = LucideIcons.bike;
    if (vehicle.vehicleType == 'commercial') typeIcon = LucideIcons.truck;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.r16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.r16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: AppDimensions.cardShadow,
        ),
        child: Row(
          children: [
            // Araç İkonu
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(typeIcon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),

            // Araç Bilgileri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.brand} ${vehicle.model}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${vehicle.variant ?? 'Standart'} • ${vehicle.year}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // TR Plaka Rozeti
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Text(
                vehicle.plate,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
