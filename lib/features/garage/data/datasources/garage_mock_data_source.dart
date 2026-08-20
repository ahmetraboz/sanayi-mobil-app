import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_model.dart';

/// Garaj Mock Veri Kaynağı (Canlı Ekleme/Silme Destekli)
class GarageMockDataSource {
  final List<VehicleModel> _vehicles = [
    const VehicleModel(
      id: 'veh_001',
      plate: '34 SAN 2026',
      brand: 'Volkswagen',
      model: 'Golf',
      year: '2023',
      variant: '1.5 eTSI',
      vehicleType: 'car',
      mileage: 45000,
      lastMaintenanceKm: '45.000 KM',
      inspectionDate: '14.11.2026',
      isInsuranceActive: true,
    ),
  ];

  Future<List<VehicleModel>> fetchVehicles() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_vehicles);
  }

  Future<VehicleModel> insertVehicle(VehicleModel vehicle) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _vehicles.add(vehicle);
    return vehicle;
  }

  Future<void> removeVehicle(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _vehicles.removeWhere((v) => v.id == vehicleId);
  }
}
