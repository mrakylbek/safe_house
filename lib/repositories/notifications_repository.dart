import 'dart:async';

import 'package:safe_house/api/api.dart';
import 'package:safe_house/models/notification.dart';

class NotificationRepository {
  Future<List<NotificationModel>> fetchNotification() async {
    try {
      final result = await APIRepository().fetchNotifications();

      if (result.statusCode == 200) {
        return (result.data['data'] as List)
            .map((notif) => NotificationModel.fromMap(notif))
            .toList();
        // return NotificationModel.fromMap(result.data['data']);
      } else {
        throw Exception('Error on fetchNotification: ${result.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }
}
