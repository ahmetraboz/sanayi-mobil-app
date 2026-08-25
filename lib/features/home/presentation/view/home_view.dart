import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/core/di/service_locator.dart';
import 'package:sanayi_mobil_app/core/widgets/app_header.dart';
import 'package:sanayi_mobil_app/features/service_booking/presentation/view/service_vehicle_selection_sheet.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'widgets/campaign_slider_widget.dart';
import 'widgets/location_bar_widget.dart';
import 'widgets/services_grid_widget.dart';

/// Ana Sayfa Görünümü (MVVM - View Katmanı)
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..loadHomeData(),
      child: const _HomeViewBody(),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  const _HomeViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading && state.banners.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (state.status == HomeStatus.error && state.banners.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Bir hata oluştu',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<HomeCubit>().loadHomeData(),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => context.read<HomeCubit>().loadHomeData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.p12),

                  // 1. Hizmet Bölgesi / Konum Çubuğu
                  const LocationBarWidget(),

                  const SizedBox(height: AppDimensions.p16),

                  // 2. Kampanya Slider
                  CampaignSliderWidget(
                    banners: state.banners,
                    onPageChanged: (index) {
                      context.read<HomeCubit>().onBannerPageChanged(index);
                    },
                  ),

                  const SizedBox(height: AppDimensions.p24),

                  // 3. Hizmetler Grid
                  ServicesGridWidget(
                    services: state.services,
                    onServiceSelected: (service) {
                      ServiceVehicleSelectionSheet.show(context, serviceTitle: service.title);
                    },
                  ),

                  const SizedBox(height: AppDimensions.p32),

                  // 4. Alt Acil Durum / Bilgi Kartı
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.p16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.08),
                            AppColors.primaryLight.withValues(alpha: 0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppDimensions.r20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppDimensions.r16),
                            ),
                            child: const Icon(
                              Icons.headset_mic_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '7/24 Yol Yardım ve Destek',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Yolda mı kaldınız? Tek tıkla acil çekici çağırın.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
