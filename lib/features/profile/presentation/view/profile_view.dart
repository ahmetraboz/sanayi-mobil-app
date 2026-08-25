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
import 'account_info_view.dart';
import 'subviews/user_services_view.dart';
import 'subviews/service_points_view.dart';
import 'subviews/user_referrals_view.dart';
import 'subviews/user_addresses_view.dart';
import 'subviews/user_cards_view.dart';
import 'subviews/language_settings_view.dart';
import 'subviews/notification_settings_view.dart';
import 'subviews/about_sanayigo_view.dart';
import 'subviews/faq_view.dart';
import 'subviews/support_center_view.dart';

/// Profil Görünümü (Tüm Menü Öğeleri Aktif & Fonksiyonel)
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
                      onTap: () {
                        final cubit = context.read<ProfileCubit>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: cubit,
                              child: AccountInfoView(user: user),
                            ),
                          ),
                        );
                      },
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const UserServicesView()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.compass,
                      title: 'Hizmet Noktalarım',
                      subtitle: 'En yakın servis ve bayiler',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ServicePointsView()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.share2,
                      title: 'Referanslarım',
                      subtitle: 'Referans geçmişinizi görüntüleyin',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => UserReferralsView(referralCode: user.referralCode)),
                        );
                      },
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const UserAddressesView()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.creditCard,
                      title: 'Kredi Kartlarım',
                      subtitle: 'Ödeme yöntemlerim',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const UserCardsView()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.translate_rounded,
                      title: 'Dil',
                      subtitle: 'Uygulama dil tercihi',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LanguageSettingsView()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.bell,
                      title: 'Bildirim Ayarları',
                      subtitle: 'Tercihler ve duyurular',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationSettingsView()),
                        );
                      },
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AboutSanayiGoView()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.messageSquare,
                      title: 'SSS',
                      subtitle: 'Sıkça sorulan sorular',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FaqView()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: LucideIcons.headphones,
                      title: 'Destek',
                      subtitle: 'Yardım için destek ekibimizle iletişime geçin',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SupportCenterView()),
                        );
                      },
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: const Text('Çıkış Yap', style: TextStyle(fontWeight: FontWeight.w800)),
                        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('İptal', style: TextStyle(color: Color(0xFF64748B))),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('Çıkış Yap', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
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
}
