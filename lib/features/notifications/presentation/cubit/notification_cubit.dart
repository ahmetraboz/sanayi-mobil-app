import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanayi_mobil_app/features/notifications/domain/repositories/i_notification_repository.dart';
import 'notification_state.dart';

/// Bildirimler ViewModel (Cubit)
class NotificationCubit extends Cubit<NotificationState> {
  final INotificationRepository _repository;

  NotificationCubit({required INotificationRepository repository})
      : _repository = repository,
        super(const NotificationState());

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading));

    try {
      final notifications = await _repository.getNotifications();
      emit(state.copyWith(
        status: NotificationStatus.loaded,
        notifications: notifications,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationStatus.error,
        errorMessage: 'Bildirimler yüklenemedi: $e',
      ));
    }
  }
}
