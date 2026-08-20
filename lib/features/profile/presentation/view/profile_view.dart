import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/core/di/service_locator.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_menu_group.dart';
import 'widgets/profile_menu_item.dart';

/// Profil Görünümü (Rabam Tasarımına Birebir Uygun)
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..loadProfile(),
      child: const _ProfileViewBody(),
    );
  }
}

class _ProfileViewBody extends StatelessWidget {
  const _ProfileViewBody();

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
          'Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading && state.user == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final user = state.user;
          if (user == null) {
            return const Center(child: Text('Profil yüklenemedi'));
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
            child: Column(
              children: [
                // 1. Üst Bilgi Kartı (Avatar, İsim, E-posta, Referans Kodu)
                ProfileHeaderCard(user: user),

                const SizedBox(height: 24),

                // 2. Menü Grubu 1: Hesap Bilgileri
                ProfileMenuGroup(
                  items: [
                    ProfileMenuItem(
                      icon: LucideIcons.edit3,
                      title: 'Hesap Bilgileri',
                      subtitle: 'Kullanıcı bilgilerinin yönetimi',
                      onTap: () => _showComingSoon(context, 'Hesap Bilgileri'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 3. Menü Grubu 2: Hizmet & Kullanım
                ProfileMenuGroup(
                  items: [
                    ProfileMenuItem(
                      icon: LucideIcons.wrench,
                      title: 'Hizmetlerim',
                      subtitle: 'Randevu ve servis takibi',
                      onTap: () => _showComingSoon(context, 'Hizmetlerim'),
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.fuel,
                      title: 'Yakıt Kullanımım',
                      subtitle: 'Aylık tüketim detayları',
                      onTap: () => _showComingSoon(context, 'Yakıt Kullanımım'),
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.compass,
                      title: 'Hizmet Noktalarım',
                      subtitle: 'En yakın servis ve bayiler',
                      onTap: () => _showComingSoon(context, 'Hizmet Noktalarım'),
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.share2,
                      title: 'Referanslarım',
                      subtitle: 'Referans geçmişinizi görüntüleyin',
                      onTap: () => _showComingSoon(context, 'Referanslarım'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 4. Menü Grubu 3: Adres, Kart, Dil, Bildirim
                ProfileMenuGroup(
                  items: [
                    ProfileMenuItem(
                      icon: LucideIcons.mapPin,
                      title: 'Adreslerim',
                      subtitle: 'Kayıtlı adres bilgilerim',
                      onTap: () => _showComingSoon(context, 'Adreslerim'),
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.creditCard,
                      title: 'Kredi Kartlarım',
                      subtitle: 'Ödeme yöntemlerim',
                      onTap: () => _showComingSoon(context, 'Kredi Kartlarım'),
                    ),
                    ProfileMenuItem(
                      icon: Icons.translate_rounded,
                      title: 'Dil',
                      subtitle: 'Uygulama dil tercihi',
                      onTap: () => _showComingSoon(context, 'Dil Tercihleri'),
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.bell,
                      title: 'Bildirim Ayarları',
                      subtitle: 'Tercihler ve duyurular',
                      onTap: () => _showComingSoon(context, 'Bildirim Ayarları'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 5. Menü Grubu 4: Hakkında, SSS, Destek
                ProfileMenuGroup(
                  items: [
                    ProfileMenuItem(
                      icon: LucideIcons.info,
                      title: 'SanayiGO Hakkında',
                      subtitle: 'SanayiGO hakkında detaylı bilgi',
                      onTap: () => _showComingSoon(context, 'SanayiGO Hakkında'),
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.messageSquare,
                      title: 'SSS',
                      subtitle: 'Sıkça sorulan sorular',
                      onTap: () => _showComingSoon(context, 'Sıkça Sorulan Sorular'),
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.headphones,
                      title: 'Destek',
                      subtitle: 'Yardım için destek ekibimizle iletişime geçin',
                      onTap: () => _showComingSoon(context, 'Destek'),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 6. Çıkış Yap Butonu
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Çıkış Yap'),
                        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('İptal'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('Çıkış Yap'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Çıkış Yap',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // 7. Sürüm Bilgisi
                const Text(
                  'Sürüm 1.0.0 (1)',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title modülü yakında eklenecek'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
