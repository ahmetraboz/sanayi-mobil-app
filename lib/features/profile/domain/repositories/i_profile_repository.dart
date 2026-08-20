import 'package:sanayi_mobil_app/features/profile/data/models/user_profile_model.dart';

/// Profil Modülü Sözleşmesi
abstract class IProfileRepository {
  Future<UserProfileModel> getUserProfile();
}
