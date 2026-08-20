import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanayi_mobil_app/features/profile/domain/repositories/i_profile_repository.dart';
import 'profile_state.dart';

/// Profil ViewModel (Cubit)
class ProfileCubit extends Cubit<ProfileState> {
  final IProfileRepository _repository;

  ProfileCubit({required IProfileRepository repository})
      : _repository = repository,
        super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final user = await _repository.getUserProfile();
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Profil bilgileri yüklenemedi: $e',
      ));
    }
  }
}
