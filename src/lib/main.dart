import 'package:easy_localization/easy_localization.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:push_notification/push_notification.dart';
import 'package:zhytomyr_polytechnic/app_constants.dart';
import 'package:zhytomyr_polytechnic/widgets/app.dart';

Future<void> main() async {
  await initLocalizationAsync();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('uk'), Locale('en')],
        path: AppConstants.translationPath,
        fallbackLocale: Locale('en'),
        child: App()),
  );
}

Future<void> initLocalizationAsync() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  initNotification;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
