// Adicionar email_validator -> https://pub.dev/packages/email_validator
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'core/firebase/firebase_options.dart';
import 'services/local_sql_service.dart';
import 'app.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseAuth.instance.setLanguageCode('pt');

  if (!kIsWeb) {
    await LocalStorageService.instance.database; // Inicializa o banco de dados local apenas se não estiver na web.
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}