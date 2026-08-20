import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/core/di/service_locator.dart';
import 'package:sanayi_mobil_app/core/widgets/app_header.dart';
import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_model.dart';
import '../cubit/garage_cubit.dart';
import '../cubit/garage_state.dart';
import 'add_vehicle_view.dart';

/// Garajım Görünümü (MVVM - Canlı Araç Listeleme & Ekleme Bağlantılı)
class GarageView extends StatelessWidget {
  const GarageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<GarageCubit>()..loadVehicles(),
      child: const _GarageViewBody(),
    );
  }
}

class _GarageViewBody extends StatelessWidget {
  const _GarageViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: BlocBuilder<GarageCubit, GarageState>(
        builder: (context, state) {
          if (state.status == GarageStatus.loading && state.vehicles.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık & Açıklama
                const Text(
                  'Garajım',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Araçlarınızı ekleyin, periyodik bakım ve muayene tarihlerini takip edin.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),

                // Araç Listesi
                if (state.vehicles.isEmpty)
                  _buildEmptyState(context)
                else
                  ...state.vehicles.map((vehicle) => _buildVehicleCard(context, vehicle)),

                const SizedBox(height: 12),

                // Yeni Araç Ekle Butonu
                InkWell(
                  onTap: () {
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
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.r16),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      boxShadow: AppDimensions.cardShadow,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColors.primary, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Yeni Araç Ekle',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 110), // Floating Bottom Nav Bar boşluğu
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, VehicleModel vehicle) {
    IconData typeIcon = LucideIcons.car;
    if (vehicle.vehicleType == 'motorcycle') typeIcon = LucideIcons.bike;
    if (vehicle.vehicleType == 'commercial') typeIcon = LucideIcons.truck;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(AppDimensions.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.r20),
        boxShadow: AppDimensions.cardShadow,
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.r12),
                ),
                child: Icon(typeIcon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.plate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vehicle.displayName,
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2, size: 18, color: AppColors.textTertiary),
                onPressed: () {
                  _showDeleteConfirmDialog(context, vehicle);
                },
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _VehicleStat(
                label: 'Son Bakım',
                value: vehicle.lastMaintenanceKm ?? '${vehicle.mileage} KM',
              ),
              _VehicleStat(
                label: 'Muayene',
                value: vehicle.inspectionDate ?? '14.11.2026',
              ),
              _VehicleStat(
                label: 'Kasko Durumu',
                value: vehicle.isInsuranceActive ? 'Aktif' : 'Pasif',
                isSuccess: vehicle.isInsuranceActive,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.r20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
      ),
      child: const Column(
        children: [
          Icon(LucideIcons.car, size: 48, color: AppColors.textTertiary),
          SizedBox(height: 12),
          Text(
            'Henüz Araç Eklenmedi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          SizedBox(height: 4),
          Text(
            'İlk aracınızı ekleyerek periyodik bakım tarihlerini ve servis fırsatlarını takip etmeye başlayın.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, VehicleModel vehicle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Aracı Sil'),
        content: Text('${vehicle.plate} plakalı aracı garajınızdan kaldırmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              context.read<GarageCubit>().deleteVehicle(vehicle.id);
              Navigator.pop(ctx);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

class _VehicleStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isSuccess;

  const _VehicleStat({
    required this.label,
    required this.value,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSuccess ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
