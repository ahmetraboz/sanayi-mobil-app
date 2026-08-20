import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/vehicle_model.dart';
import '../../domain/repositories/i_garage_repository.dart';
import 'garage_state.dart';

/// Garaj ViewModel (Cubit)
class GarageCubit extends Cubit<GarageState> {
  final IGarageRepository _repository;

  GarageCubit({required IGarageRepository repository})
      : _repository = repository,
        super(const GarageState());

  Future<void> loadVehicles() async {
    emit(state.copyWith(status: GarageStatus.loading));

    try {
      final list = await _repository.getVehicles();
      emit(state.copyWith(
        status: GarageStatus.loaded,
        vehicles: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GarageStatus.error,
        errorMessage: 'Araçlar yüklenemedi: $e',
      ));
    }
  }

  Future<bool> addNewVehicle({
    required String plate,
    required String brand,
    required String model,
    required String year,
    String? variant,
    required String vehicleType,
    required int mileage,
  }) async {
    emit(state.copyWith(isSubmitting: true));

    try {
      final newVehicle = VehicleModel(
        id: 'veh_${DateTime.now().millisecondsSinceEpoch}',
        plate: plate.toUpperCase().trim(),
        brand: brand.trim(),
        model: model.trim(),
        year: year.trim(),
        variant: variant?.trim().isNotEmpty == true ? variant!.trim() : null,
        vehicleType: vehicleType,
        mileage: mileage,
        lastMaintenanceKm: '$mileage KM',
        inspectionDate: '20.08.2027',
        isInsuranceActive: true,
      );

      await _repository.addVehicle(newVehicle);
      final updatedList = await _repository.getVehicles();

      emit(state.copyWith(
        isSubmitting: false,
        status: GarageStatus.loaded,
        vehicles: updatedList,
        successMessage: '$plate plakalı araç başarıyla garaja eklendi!',
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Araç eklenirken bir hata oluştu: $e',
      ));
      return false;
    }
  }

  Future<void> deleteVehicle(String id) async {
    try {
      await _repository.deleteVehicle(id);
      final updatedList = await _repository.getVehicles();
      emit(state.copyWith(vehicles: updatedList));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Araç silinemedi: $e'));
    }
  }
}
