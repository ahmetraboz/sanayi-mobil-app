import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_model.dart';

/// Garaj Modülü Sözleşmesi
abstract class IGarageRepository {
  Future<List<VehicleModel>> getVehicles();
  Future<VehicleModel> addVehicle(VehicleModel vehicle);
  Future<void> deleteVehicle(String vehicleId);
}
