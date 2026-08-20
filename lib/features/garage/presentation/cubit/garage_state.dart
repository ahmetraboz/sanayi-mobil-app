import '../../data/models/vehicle_model.dart';

enum GarageStatus { initial, loading, loaded, error }

class GarageState {
  final GarageStatus status;
  final List<VehicleModel> vehicles;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const GarageState({
    this.status = GarageStatus.initial,
    this.vehicles = const [],
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
  });

  GarageState copyWith({
    GarageStatus? status,
    List<VehicleModel>? vehicles,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
  }) {
    return GarageState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
