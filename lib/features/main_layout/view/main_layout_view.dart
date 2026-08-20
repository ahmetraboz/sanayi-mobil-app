import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../campaign/presentation/view/campaign_view.dart';
import '../../garage/presentation/view/garage_view.dart';
import '../../home/presentation/view/home_view.dart';
import '../../scan/presentation/view/qr_scan_modal.dart';
import '../../support/presentation/view/support_view.dart';
import '../cubit/navigation_cubit.dart';
import 'widgets/custom_bottom_nav_bar.dart';

/// Uygulamanın Ana Çerçeve Görünümü (Bottom Nav Bar & Tab Yönetimi)
class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NavigationCubit>(),
      child: const _MainLayoutViewBody(),
    );
  }
}

class _MainLayoutViewBody extends StatelessWidget {
  const _MainLayoutViewBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: state.activeTab.index,
            children: const [
              HomeView(),
              GarageView(),
              CampaignView(),
              SupportView(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            activeTab: state.activeTab,
            onTabSelected: (tab) {
              context.read<NavigationCubit>().setTab(tab);
            },
            onCenterActionTap: () {
              QrScanModal.show(context);
            },
          ),
        );
      },
    );
  }
}
