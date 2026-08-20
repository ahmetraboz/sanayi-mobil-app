import '../../data/models/campaign_banner_model.dart';
import '../../data/models/service_category_model.dart';

/// Home Modülü için Soyut Repository Sözleşmesi
abstract class IHomeRepository {
  /// Kampanya banner listesini getirir
  Future<List<CampaignBannerModel>> getCampaignBanners();

  /// Ana sayfa hizmet kategorilerini getirir
  Future<List<ServiceCategoryModel>> getServiceCategories();
}
