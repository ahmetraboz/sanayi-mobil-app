import 'package:sanayi_mobil_app/features/profile/data/datasources/profile_mock_data_source.dart';
import 'package:sanayi_mobil_app/features/profile/data/models/user_profile_model.dart';
import 'package:sanayi_mobil_app/features/profile/domain/repositories/i_profile_repository.dart';

/// IProfileRepository Implementasyonu
class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileMockDataSource _dataSource;

  ProfileRepositoryImpl({ProfileMockDataSource? dataSource})
      : _dataSource = dataSource ?? ProfileMockDataSource();

  @override
  Future<UserProfileModel> getUserProfile() async {
    return await _dataSource.fetchUserProfile();
  }
}
