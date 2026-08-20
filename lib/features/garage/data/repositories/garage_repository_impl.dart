import 'package:sanayi_mobil_app/features/garage/data/datasources/garage_mock_data_source.dart';
import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_model.dart';
import 'package:sanayi_mobil_app/features/garage/domain/repositories/i_garage_repository.dart';

/// IGarageRepository Implementasyonu
class GarageRepositoryImpl implements IGarageRepository {
  final GarageMockDataSource _dataSource;

  GarageRepositoryImpl({GarageMockDataSource? dataSource})
      : _dataSource = dataSource ?? GarageMockDataSource();

  @override
  Future<List<VehicleModel>> getVehicles() async {
    return await _dataSource.fetchVehicles();
  }

  @override
  Future<VehicleModel> addVehicle(VehicleModel vehicle) async {
    return await _dataSource.insertVehicle(vehicle);
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    return await _dataSource.removeVehicle(vehicleId);
  }
}
