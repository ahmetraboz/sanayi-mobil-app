import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanayi_mobil_app/features/profile/data/models/user_profile_model.dart';
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

  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    if (state.user == null) return;

    final parts = name.trim().split(' ');
    String initials = '';
    if (parts.isNotEmpty && parts.first.isNotEmpty) {
      initials += parts.first[0].toUpperCase();
    }
    if (parts.length > 1 && parts.last.isNotEmpty) {
      initials += parts.last[0].toUpperCase();
    }
    if (initials.isEmpty) initials = 'SB';

    final updatedUser = state.user!.copyWith(
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      initials: initials,
    );

    emit(state.copyWith(user: updatedUser));
  }

  void deleteAccount() {
    emit(state.copyWith(
      status: ProfileStatus.loaded,
      user: const UserProfileModel(
        id: 'user_guest',
        name: 'Misafir Kullanıcı',
        email: 'misafir@sanayigo.com',
        phone: '+90 500 000 00 00',
        initials: 'MK',
        referralCode: 'YENI2026',
        balance: 0.0,
      ),
    ));
  }
}
