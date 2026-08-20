/// Araç Veri Modeli
class VehicleModel {
  final String id;
  final String plate;
  final String brand;
  final String model;
  final String year;
  final String? variant;
  final String vehicleType; // 'car', 'motorcycle', 'commercial'
  final int mileage;
  final String? lastMaintenanceKm;
  final String? inspectionDate;
  final bool isInsuranceActive;

  const VehicleModel({
    required this.id,
    required this.plate,
    required this.brand,
    required this.model,
    required this.year,
    this.variant,
    this.vehicleType = 'car',
    required this.mileage,
    this.lastMaintenanceKm,
    this.inspectionDate,
    this.isInsuranceActive = true,
  });

  String get displayName => '$brand $model${variant != null ? ' $variant' : ''} ($year)';

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      plate: json['plate'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as String,
      variant: json['variant'] as String?,
      vehicleType: json['vehicleType'] as String? ?? 'car',
      mileage: json['mileage'] as int? ?? 0,
      lastMaintenanceKm: json['lastMaintenanceKm'] as String?,
      inspectionDate: json['inspectionDate'] as String?,
      isInsuranceActive: json['isInsuranceActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plate': plate,
      'brand': brand,
      'model': model,
      'year': year,
      'variant': variant,
      'vehicleType': vehicleType,
      'mileage': mileage,
      'lastMaintenanceKm': lastMaintenanceKm,
      'inspectionDate': inspectionDate,
      'isInsuranceActive': isInsuranceActive,
    };
  }
}
