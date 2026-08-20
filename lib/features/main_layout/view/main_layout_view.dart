import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanayi_mobil_app/core/di/service_locator.dart';
import 'package:sanayi_mobil_app/features/campaign/presentation/view/campaign_view.dart';
import 'package:sanayi_mobil_app/features/garage/presentation/view/garage_view.dart';
import 'package:sanayi_mobil_app/features/home/presentation/view/home_view.dart';
import 'package:sanayi_mobil_app/features/scan/presentation/view/qr_scan_modal.dart';
import 'package:sanayi_mobil_app/features/support/presentation/view/support_view.dart';
import 'package:sanayi_mobil_app/features/main_layout/cubit/navigation_cubit.dart';
import 'widgets/custom_bottom_nav_bar.dart';

/// Yüzen iPhone Nav Bar ve Akıcı Kayan Ekran Çerçevesi
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

class _MainLayoutViewBody extends StatefulWidget {
  const _MainLayoutViewBody();

  @override
  State<_MainLayoutViewBody> createState() => _MainLayoutViewBodyState();
}

class _MainLayoutViewBodyState extends State<_MainLayoutViewBody> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationCubit, NavigationState>(
      listenWhen: (previous, current) => previous.activeTab != current.activeTab,
      listener: (context, state) {
        if (_pageController.hasClients) {
          final targetPage = state.activeTab.index;
          if (_pageController.page?.round() != targetPage) {
            _pageController.animateToPage(
              targetPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          body: PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              final tab = BottomNavTab.values[index];
              context.read<NavigationCubit>().setTab(tab);
            },
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
