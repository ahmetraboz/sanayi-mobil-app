import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/models/vehicle_service_record_model.dart';
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
    String? fuelType,
    String? transmission,
    String? color,
    String? chassisNumber,
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
        fuelType: fuelType ?? 'Benzin',
        transmission: transmission ?? 'Otomatik',
        color: color ?? 'Beyaz',
        chassisNumber: chassisNumber,
        trafficInsuranceDate: '20.08.2027',
        kaskoDate: '20.08.2027',
        serviceRecords: [],
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

  Future<bool> updateVehicle(VehicleModel updatedVehicle) async {
    emit(state.copyWith(isSubmitting: true));

    try {
      await _repository.updateVehicle(updatedVehicle);
      final updatedList = await _repository.getVehicles();

      emit(state.copyWith(
        isSubmitting: false,
        status: GarageStatus.loaded,
        vehicles: updatedList,
        successMessage: 'Araç bilgileri başarıyla güncellendi!',
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Araç güncellenirken bir hata oluştu: $e',
      ));
      return false;
    }
  }

  Future<bool> addServiceRecord({
    required String vehicleId,
    required String serviceName,
    required String category,
    required String date,
    required int mileageAtService,
    required String serviceProvider,
    required double cost,
    String? invoiceNo,
    String? notes,
    List<String> items = const [],
  }) async {
    emit(state.copyWith(isSubmitting: true));

    try {
      final record = VehicleServiceRecordModel(
        id: 'srv_${DateTime.now().millisecondsSinceEpoch}',
        vehicleId: vehicleId,
        serviceName: serviceName,
        category: category,
        date: date,
        mileageAtService: mileageAtService,
        serviceProvider: serviceProvider,
        cost: cost,
        invoiceNo: invoiceNo,
        notes: notes,
        items: items,
        status: 'completed',
      );

      await _repository.addServiceRecord(vehicleId, record);
      final updatedList = await _repository.getVehicles();

      emit(state.copyWith(
        isSubmitting: false,
        status: GarageStatus.loaded,
        vehicles: updatedList,
        successMessage: 'Hizmet kaydı başarıyla eklendi!',
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Hizmet kaydı eklenirken bir hata oluştu: $e',
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
