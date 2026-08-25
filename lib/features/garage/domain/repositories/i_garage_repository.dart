import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_model.dart';
import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_service_record_model.dart';

/// Garaj Modülü Sözleşmesi
abstract class IGarageRepository {
  Future<List<VehicleModel>> getVehicles();
  Future<VehicleModel> addVehicle(VehicleModel vehicle);
  Future<VehicleModel> updateVehicle(VehicleModel vehicle);
  Future<void> deleteVehicle(String vehicleId);
  Future<VehicleServiceRecordModel> addServiceRecord(
    String vehicleId,
    VehicleServiceRecordModel record,
  );
}
