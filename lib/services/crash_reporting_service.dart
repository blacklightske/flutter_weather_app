import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashReportingService {
  final FirebaseCrashlytics crashlytics;

  CrashReportingService({FirebaseCrashlytics? crashlyticsInstance})
    : crashlytics = crashlyticsInstance ?? FirebaseCrashlytics.instance;
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  }) async {
    await crashlytics.recordError(error, stackTrace, reason: reason);
  }

  Future<void> log(String message) async {
    crashlytics.log(message);
  }

  Future<void> setKey(String key, Object value) async {
    await crashlytics.setCustomKey(key, value);
  }
}
