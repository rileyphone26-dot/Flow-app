import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:fvp/fvp.dart' as fvp;
import 'package:spark/src/core/di/service_locator.dart';
import 'package:spark/src/core/notifications/push_notification_service.dart';
import 'package:spark/src/core/storage/cache/download_manager_interface.dart';
import 'package:spark/src/core/storage/storage.dart';
import 'package:spark/src/core/ui/theme/data/models/app_theme.dart';
import 'package:spark/src/core/utils/logging/logging.dart';
import 'package:spark/src/core/utils/logging/riverpod_logger.dart';
import 'package:spark/src/sprk_app.dart';

Future<void> main() => runFlowApp();

Future<void> runFlowApp({
  LocalStorageInterface? preferencesStorage,
  LocalStorageInterface? secureStorage,
  riverpod.ProviderContainer? providerContainer,
  Future<DownloadManagerInterface> Function()? initializeDownloadManager,
  Future<PushNotificationService> Function()? initializePushNotifications,
}) async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.deferFirstFrame();
  var didAllowFirstFrame = false;

  void allowFirstFrame() {
    if (didAllowFirstFrame) return;
    didAllowFirstFrame = true;
    binding.allowFirstFrame();
  }

  try {
    await dotenv.load();

    // Android reads options from android/app/google-services.json.
    // Web auth stays disabled until Flow's Firebase Web app is configured.
    if (!kIsWeb) await Firebase.initializeApp();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(AppTheme.darkSystemUiStyle);
    fvp.registerWith();

    await initServiceLocator(
      preferencesStorage: preferencesStorage,
      secureStorage: secureStorage,
      initializeDownloadManager: initializeDownloadManager,
      initializePushNotifications: initializePushNotifications,
    );

    sl<LogService>().setGlobalLogLevel(
      kDebugMode ? LogLevel.debug : LogLevel.warning,
    );

    final container = providerContainer ??
        riverpod.ProviderContainer(observers: [SparkRiverpodLogger()]);
    runApp(
      riverpod.UncontrolledProviderScope(
        container: container,
        child: SprkApp(onFirstRouteReady: allowFirstFrame),
      ),
    );
  } catch (_) {
    allowFirstFrame();
    rethrow;
  }
}
