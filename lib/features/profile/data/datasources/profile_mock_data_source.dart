import 'package:sanayi_mobil_app/features/profile/data/models/user_profile_model.dart';

/// Profil Mock Veri Kaynağı
class ProfileMockDataSource {
  Future<UserProfileModel> fetchUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return const UserProfileModel(
      id: 'usr_001',
      name: 'Ahmet Boz',
      email: 'aboz11897@gmail.com',
      initials: 'AB',
      referralCode: 'S7Z9TLURFR',
      balance: 0.0,
    );
  }
}
