import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyCcZZcmp88aOSn00puZSWQFwomfY8IHLeE",
      appId: "1:614796990557:web:425a0cf060e689395f15b4",
      messagingSenderId: "614796990557",
      projectId: "app-distribuidora-ftg",
      storageBucket: "app-distribuidora-ftg.firebasestorage.app",
      measurementId: "G-69W8N8CH2C",
      authDomain: "app-distribuidora-ftg.firebaseapp.com");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1SNmFHyboSBXFH0BXhhrDrx8ORUQmDSg',
    appId: '1:614796990557:android:f8aff5ec673944755f15b4',
    messagingSenderId: '614796990557',
    projectId: 'app-distribuidora-ftg',
    storageBucket: 'app-distribuidora-ftg.firebasestorage.app',
  );
}
