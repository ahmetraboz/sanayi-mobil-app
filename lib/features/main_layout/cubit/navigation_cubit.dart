import 'package:flutter_bloc/flutter_bloc.dart';

/// Alt Gezinme Çubuğu Sekmeleri
enum BottomNavTab { home, garage, campaign, support }

class NavigationState {
  final BottomNavTab activeTab;

  const NavigationState({this.activeTab = BottomNavTab.home});
}

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void setTab(BottomNavTab tab) {
    if (state.activeTab != tab) {
      emit(NavigationState(activeTab: tab));
    }
  }

  void openHome() => setTab(BottomNavTab.home);
  void openGarage() => setTab(BottomNavTab.garage);
  void openCampaign() => setTab(BottomNavTab.campaign);
  void openSupport() => setTab(BottomNavTab.support);
}
