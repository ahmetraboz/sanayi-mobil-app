import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/core/di/service_locator.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';

/// Bildirimler Görünümü (Profil ile Tam Uyumlu Giriş/Çıkış ve Tasarım Dili)
class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationCubit>()..loadNotifications(),
      child: const _NotificationViewBody(),
    );
  }
}

class _NotificationViewBody extends StatelessWidget {
  const _NotificationViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Bildirimler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.status == NotificationStatus.loading && state.notifications.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state.notifications.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => context.read<NotificationCubit>().loadNotifications(),
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppDimensions.p20),
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = state.notifications[index];
                return Container(
                  padding: const EdgeInsets.all(AppDimensions.p16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.r16),
                    boxShadow: AppDimensions.cardShadow,
                    border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.message,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // İkon Rozeti
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: AppColors.divider.withValues(alpha: 0.7),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.bellOff,
                  size: 38,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Başlık
            const Text(
              'Henüz Bildiriminiz Yok',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),

            // Açıklama
            const Text(
              'Kampanyalar, randevu hatırlatmaları ve servis durum güncellemeleri burada listelenecektir.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
