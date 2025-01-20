import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final notificationSettingsProvider = StateProvider<NotificationSettings>((ref) {
  return const NotificationSettings();
});

class NotificationSettings {
  final bool isEnabled;
  final int reminderHour;
  final int reminderMinute;

  const NotificationSettings({
    this.isEnabled = true,
    this.reminderHour = 20,
    this.reminderMinute = 0,
  });

  NotificationSettings copyWith({
    bool? isEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return NotificationSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }
}
