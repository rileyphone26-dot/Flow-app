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
Future<void> main() async {
 final binding=WidgetsFlutterBinding.ensureInitialized(); binding.deferFirstFrame();
 try {
  await dotenv.load();
  if(!kIsWeb) await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(AppTheme.darkSystemUiStyle); fvp.registerWith();
  await initServiceLocator();
  sl<LogService>().setGlobalLogLevel(kDebugMode?LogLevel.debug:LogLevel.warning);
  runApp(riverpod.ProviderScope(child:SprkApp(onFirstRouteReady:binding.allowFirstFrame)));
 } catch(_){binding.allowFirstFrame();rethrow;}
}