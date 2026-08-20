import '../datasources/home_mock_data_source.dart';
import '../models/campaign_banner_model.dart';
import '../models/service_category_model.dart';
import '../../domain/repositories/i_home_repository.dart';

/// IHomeRepository Implementasyonu
class HomeRepositoryImpl implements IHomeRepository {
  final HomeMockDataSource _dataSource;

  HomeRepositoryImpl({HomeMockDataSource? dataSource})
      : _dataSource = dataSource ?? HomeMockDataSource();

  @override
  Future<List<CampaignBannerModel>> getCampaignBanners() async {
    return await _dataSource.fetchBanners();
  }

  @override
  Future<List<ServiceCategoryModel>> getServiceCategories() async {
    return await _dataSource.fetchServices();
  }
}
