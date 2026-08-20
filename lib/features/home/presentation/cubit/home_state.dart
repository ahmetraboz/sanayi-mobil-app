import '../../data/models/campaign_banner_model.dart';
import '../../data/models/service_category_model.dart';

enum HomeStatus { initial, loading, loaded, error }

/// Home Ekranı State Tanımı
class HomeState {
  final HomeStatus status;
  final List<CampaignBannerModel> banners;
  final List<ServiceCategoryModel> services;
  final int activeBannerIndex;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.banners = const [],
    this.services = const [],
    this.activeBannerIndex = 0,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<CampaignBannerModel>? banners,
    List<ServiceCategoryModel>? services,
    int? activeBannerIndex,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
      services: services ?? this.services,
      activeBannerIndex: activeBannerIndex ?? this.activeBannerIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
