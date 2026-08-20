import 'package:sanayi_mobil_app/features/notifications/data/models/notification_model.dart';

/// Bildirim Mock Veri Kaynağı
class NotificationMockDataSource {
  Future<List<NotificationModel>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Şimdilik boş liste (Empty State UI)
    return const [];
  }
}
