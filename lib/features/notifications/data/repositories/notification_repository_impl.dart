import 'package:sanayi_mobil_app/features/notifications/data/datasources/notification_mock_data_source.dart';
import 'package:sanayi_mobil_app/features/notifications/data/models/notification_model.dart';
import 'package:sanayi_mobil_app/features/notifications/domain/repositories/i_notification_repository.dart';

/// INotificationRepository Implementasyonu
class NotificationRepositoryImpl implements INotificationRepository {
  final NotificationMockDataSource _dataSource;

  NotificationRepositoryImpl({NotificationMockDataSource? dataSource})
      : _dataSource = dataSource ?? NotificationMockDataSource();

  @override
  Future<List<NotificationModel>> getNotifications() async {
    return await _dataSource.fetchNotifications();
  }
}
