import 'vehicle_service_record_model.dart';

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

  // Genişletilmiş Detay Bilgileri
  final String? fuelType; // 'Benzin', 'Dizel', 'Hibrit', 'Elektrik', 'LPG'
  final String? transmission; // 'Otomatik', 'Manuel', 'Yarı Otomatik'
  final String? color;
  final String? chassisNumber; // Şasi No
  final String? enginePower; // örn: 150 HP
  final String? engineDisplacement; // örn: 1498 cc
  final String? trafficInsuranceDate; // Trafik sigortası bitiş tarihi
  final String? kaskoDate; // Kasko bitiş tarihi
  final String? tramerInfo; // 'Tamamı orijinaldir', '2 Parça Boyalı' vb.
  final List<String> photos;
  final Map<String, String> documents; // {'Ruhsat': 'url...', 'Kasko': 'url...'}
  final List<VehicleServiceRecordModel> serviceRecords;

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
    this.fuelType,
    this.transmission,
    this.color,
    this.chassisNumber,
    this.enginePower,
    this.engineDisplacement,
    this.trafficInsuranceDate,
    this.kaskoDate,
    this.tramerInfo = 'Tamamı orijinaldir',
    this.photos = const [],
    this.documents = const {},
    this.serviceRecords = const [],
  });

  String get displayName => '$brand $model${variant != null ? ' $variant' : ''} ($year)';

  /// Profil Doluluk Oranı (0.0 - 1.0)
  double get completionRatio {
    int score = 0;
    const int total = 8;
    if (plate.isNotEmpty) score++;
    if (brand.isNotEmpty && model.isNotEmpty) score++;
    if (mileage > 0) score++;
    if (tramerInfo != null && tramerInfo!.isNotEmpty) score++;
    if (chassisNumber != null && chassisNumber!.isNotEmpty) score++;
    if (inspectionDate != null && inspectionDate!.isNotEmpty) score++;
    if (trafficInsuranceDate != null && trafficInsuranceDate!.isNotEmpty) score++;
    if (photos.isNotEmpty || documents.isNotEmpty) score++;
    return score / total;
  }

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
      fuelType: json['fuelType'] as String?,
      transmission: json['transmission'] as String?,
      color: json['color'] as String?,
      chassisNumber: json['chassisNumber'] as String?,
      enginePower: json['enginePower'] as String?,
      engineDisplacement: json['engineDisplacement'] as String?,
      trafficInsuranceDate: json['trafficInsuranceDate'] as String?,
      kaskoDate: json['kaskoDate'] as String?,
      tramerInfo: json['tramerInfo'] as String? ?? 'Tamamı orijinaldir',
      photos: (json['photos'] as List<dynamic>?)?.cast<String>() ?? const [],
      documents: (json['documents'] as Map<String, dynamic>?)?.cast<String, String>() ?? const {},
      serviceRecords: (json['serviceRecords'] as List<dynamic>?)
              ?.map((e) => VehicleServiceRecordModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
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
      'fuelType': fuelType,
      'transmission': transmission,
      'color': color,
      'chassisNumber': chassisNumber,
      'enginePower': enginePower,
      'engineDisplacement': engineDisplacement,
      'trafficInsuranceDate': trafficInsuranceDate,
      'kaskoDate': kaskoDate,
      'tramerInfo': tramerInfo,
      'photos': photos,
      'documents': documents,
      'serviceRecords': serviceRecords.map((e) => e.toJson()).toList(),
    };
  }

  VehicleModel copyWith({
    String? id,
    String? plate,
    String? brand,
    String? model,
    String? year,
    String? variant,
    String? vehicleType,
    int? mileage,
    String? lastMaintenanceKm,
    String? inspectionDate,
    bool? isInsuranceActive,
    String? fuelType,
    String? transmission,
    String? color,
    String? chassisNumber,
    String? enginePower,
    String? engineDisplacement,
    String? trafficInsuranceDate,
    String? kaskoDate,
    String? tramerInfo,
    List<String>? photos,
    Map<String, String>? documents,
    List<VehicleServiceRecordModel>? serviceRecords,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      variant: variant ?? this.variant,
      vehicleType: vehicleType ?? this.vehicleType,
      mileage: mileage ?? this.mileage,
      lastMaintenanceKm: lastMaintenanceKm ?? this.lastMaintenanceKm,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      isInsuranceActive: isInsuranceActive ?? this.isInsuranceActive,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      color: color ?? this.color,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      enginePower: enginePower ?? this.enginePower,
      engineDisplacement: engineDisplacement ?? this.engineDisplacement,
      trafficInsuranceDate: trafficInsuranceDate ?? this.trafficInsuranceDate,
      kaskoDate: kaskoDate ?? this.kaskoDate,
      tramerInfo: tramerInfo ?? this.tramerInfo,
      photos: photos ?? this.photos,
      documents: documents ?? this.documents,
      serviceRecords: serviceRecords ?? this.serviceRecords,
    );
  }
}
