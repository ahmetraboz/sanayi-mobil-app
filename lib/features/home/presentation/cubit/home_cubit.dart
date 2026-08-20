import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_home_repository.dart';
import 'home_state.dart';

/// Home ViewModel (Cubit)
class HomeCubit extends Cubit<HomeState> {
  final IHomeRepository _repository;

  HomeCubit({required IHomeRepository repository})
      : _repository = repository,
        super(const HomeState());

  /// Sayfa ilk açıldığında banner ve servisleri yükler
  Future<void> loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final results = await Future.wait([
        _repository.getCampaignBanners(),
        _repository.getServiceCategories(),
      ]);

      emit(state.copyWith(
        status: HomeStatus.loaded,
        banners: results[0] as dynamic,
        services: results[1] as dynamic,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Veriler yüklenirken bir hata oluştu: $e',
      ));
    }
  }

  /// Aktif slider sayfasını günceller
  void onBannerPageChanged(int index) {
    emit(state.copyWith(activeBannerIndex: index));
  }
}
