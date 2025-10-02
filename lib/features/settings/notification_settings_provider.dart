import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:so_vuon/core/services/local_notification_service.dart';
import 'package:so_vuon/l10n/app_localizations.dart';

// Keys for shared_preferences
const String _notificationsEnabledKey = 'notificationsEnabled';
const String _notificationTimeHourKey = 'notificationTimeHour';
const String _notificationTimeMinuteKey = 'notificationTimeMinute';

// Represents the state of notification settings
@immutable
class NotificationSettings {
  final bool areNotificationsEnabled;
  final TimeOfDay notificationTime;

  const NotificationSettings({
    required this.areNotificationsEnabled,
    required this.notificationTime,
  });

  NotificationSettings copyWith({
    bool? areNotificationsEnabled,
    TimeOfDay? notificationTime,
  }) {
    return NotificationSettings(
      areNotificationsEnabled: areNotificationsEnabled ?? this.areNotificationsEnabled,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }
}

// Notifier for managing notification settings
class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  final Ref _ref;

  NotificationSettingsNotifier(this._ref)
      : super(const NotificationSettings(areNotificationsEnabled: false, notificationTime: TimeOfDay(hour: 21, minute: 0))) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final areEnabled = prefs.getBool(_notificationsEnabledKey) ?? false;
    final hour = prefs.getInt(_notificationTimeHourKey) ?? 21;
    final minute = prefs.getInt(_notificationTimeMinuteKey) ?? 0;
    final notificationTime = TimeOfDay(hour: hour, minute: minute);

    state = NotificationSettings(
      areNotificationsEnabled: areEnabled,
      notificationTime: notificationTime,
    );
  }

  Future<void> setNotificationsEnabled(BuildContext context, bool enabled) async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
    state = state.copyWith(areNotificationsEnabled: enabled);

    if (enabled) {
      await _ref.read(localNotificationServiceProvider).scheduleDailyReminder(
        state.notificationTime,
        l10n.notificationTitle,
        l10n.notificationBody,
      );
    } else {
      await _ref.read(localNotificationServiceProvider).cancelAllNotifications();
    }
  }

  Future<void> setNotificationTime(BuildContext context, TimeOfDay time) async {
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_notificationTimeHourKey, time.hour);
    await prefs.setInt(_notificationTimeMinuteKey, time.minute);
    state = state.copyWith(notificationTime: time);

    if (state.areNotificationsEnabled) {
      await _ref.read(localNotificationServiceProvider).scheduleDailyReminder(
        time,
        l10n.notificationTitle,
        l10n.notificationBody,
      );
    }
  }
}

// Provider for easy access to the notifier
final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  return NotificationSettingsNotifier(ref);
});
