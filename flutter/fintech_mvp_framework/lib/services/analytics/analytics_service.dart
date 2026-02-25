// Stub for analytics events (session start, level complete, hint used).
abstract class AnalyticsService {
  void logEvent(String name, {Map<String, Object?> parameters = const {}});
}

class PrintAnalytics implements AnalyticsService {
  @override
  void logEvent(String name, {Map<String, Object?> parameters = const {}}) {
    // ignore: avoid_print
    print('ANALYTICS: $name -> $parameters');
  }
}
