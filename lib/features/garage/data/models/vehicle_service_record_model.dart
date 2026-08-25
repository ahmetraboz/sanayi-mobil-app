/// Araç Hizmet & Bakım Kayıt Modeli
class VehicleServiceRecordModel {
  final String id;
  final String vehicleId;
  final String serviceName;
  final String category; // 'maintenance', 'wash', 'tires', 'repair', 'expertise', 'other'
  final String date;
  final int mileageAtService;
  final String serviceProvider;
  final double cost;
  final String? invoiceNo;
  final String? notes;
  final List<String> items;
  final String status; // 'completed', 'scheduled', 'cancelled'

  const VehicleServiceRecordModel({
    required this.id,
    required this.vehicleId,
    required this.serviceName,
    required this.category,
    required this.date,
    required this.mileageAtService,
    required this.serviceProvider,
    required this.cost,
    this.invoiceNo,
    this.notes,
    this.items = const [],
    this.status = 'completed',
  });

  factory VehicleServiceRecordModel.fromJson(Map<String, dynamic> json) {
    return VehicleServiceRecordModel(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      serviceName: json['serviceName'] as String,
      category: json['category'] as String? ?? 'maintenance',
      date: json['date'] as String,
      mileageAtService: json['mileageAtService'] as int? ?? 0,
      serviceProvider: json['serviceProvider'] as String,
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      invoiceNo: json['invoiceNo'] as String?,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>?)?.cast<String>() ?? [],
      status: json['status'] as String? ?? 'completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'serviceName': serviceName,
      'category': category,
      'date': date,
      'mileageAtService': mileageAtService,
      'serviceProvider': serviceProvider,
      'cost': cost,
      'invoiceNo': invoiceNo,
      'notes': notes,
      'items': items,
      'status': status,
    };
  }

  VehicleServiceRecordModel copyWith({
    String? id,
    String? vehicleId,
    String? serviceName,
    String? category,
    String? date,
    int? mileageAtService,
    String? serviceProvider,
    double? cost,
    String? invoiceNo,
    String? notes,
    List<String>? items,
    String? status,
  }) {
    return VehicleServiceRecordModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      serviceName: serviceName ?? this.serviceName,
      category: category ?? this.category,
      date: date ?? this.date,
      mileageAtService: mileageAtService ?? this.mileageAtService,
      serviceProvider: serviceProvider ?? this.serviceProvider,
      cost: cost ?? this.cost,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      status: status ?? this.status,
    );
  }
}
