import 'package:sanayi_mobil_app/features/notifications/data/models/notification_model.dart';

/// Bildirim Modülü Sözleşmesi
abstract class INotificationRepository {
  Future<List<NotificationModel>> getNotifications();
}
