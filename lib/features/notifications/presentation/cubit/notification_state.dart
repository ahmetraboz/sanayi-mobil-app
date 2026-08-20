import 'package:sanayi_mobil_app/features/notifications/data/models/notification_model.dart';

enum NotificationStatus { initial, loading, loaded, error }

class NotificationState {
  final NotificationStatus status;
  final List<NotificationModel> notifications;
  final String? errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.errorMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationModel>? notifications,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
