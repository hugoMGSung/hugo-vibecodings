// Stub for Push/Local notifications (daily challenge reminder, streak, etc.).
abstract class NotificationsService {
  Future<void> init();
  Future<void> scheduleDailyReminder({required int hour, required int minute});
}

class NoopNotifications implements NotificationsService {
  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleDailyReminder({required int hour, required int minute}) async {}
}
