import 'package:sanayi_mobil_app/features/profile/data/models/user_profile_model.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState {
  final ProfileStatus status;
  final UserProfileModel? user;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileModel? user,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
