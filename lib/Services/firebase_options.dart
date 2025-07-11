// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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
    apiKey: 'AIzaSyDrlyNILf1m32pAY_5zC59nQTgkf6AfbVs',
    appId: '1:909400364024:web:2dfc0a0bc961a690a6fc0d',
    messagingSenderId: '909400364024',
    projectId: 'beykoz-app',
    authDomain: 'beykoz-app.firebaseapp.com',
    storageBucket: 'beykoz-app.firebasestorage.app',
    measurementId: 'G-XDKFQNVW01',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdfrhdYfpPxOpcT8jqt-xcJMAXIfK4xUQ',
    appId: '1:909400364024:android:5a4c000ba18cb88da6fc0d',
    messagingSenderId: '909400364024',
    projectId: 'beykoz-app',
    storageBucket: 'beykoz-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxBRfIqBgffvDzq2Ky2VbwJ0D8hlmLyTA',
    appId: '1:909400364024:ios:568a06fcabfb7d87a6fc0d',
    messagingSenderId: '909400364024',
    projectId: 'beykoz-app',
    storageBucket: 'beykoz-app.firebasestorage.app',
    iosBundleId: 'com.beykoz.beykoz',
  );
}
