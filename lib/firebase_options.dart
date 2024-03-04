// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyDKxbmXJxwmP74l5HeS3AuzEOI5-V7eiWY',
    appId: '1:883363908242:web:681a3cc3331a68ddfc344b',
    messagingSenderId: '883363908242',
    projectId: 'testproj-7bc0d',
    authDomain: 'testproj-7bc0d.firebaseapp.com',
    databaseURL: 'https://testproj-7bc0d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'testproj-7bc0d.appspot.com',
    measurementId: 'G-SEPZ6SERKC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnAUdaXSCTl3mn66aL9ZRjgsRZ35-hh4M',
    appId: '1:883363908242:android:8745140b216ed8e1fc344b',
    messagingSenderId: '883363908242',
    projectId: 'testproj-7bc0d',
    databaseURL: 'https://testproj-7bc0d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'testproj-7bc0d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAFcMvSSU0P6jz9mWsWoKMgrMz02JwBa-o',
    appId: '1:883363908242:ios:c58dc5f35baee6e1fc344b',
    messagingSenderId: '883363908242',
    projectId: 'testproj-7bc0d',
    databaseURL: 'https://testproj-7bc0d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'testproj-7bc0d.appspot.com',
    iosBundleId: 'com.example.ucartest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAFcMvSSU0P6jz9mWsWoKMgrMz02JwBa-o',
    appId: '1:883363908242:ios:afe850ec3ee25e97fc344b',
    messagingSenderId: '883363908242',
    projectId: 'testproj-7bc0d',
    databaseURL: 'https://testproj-7bc0d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'testproj-7bc0d.appspot.com',
    iosBundleId: 'com.example.ucartest.RunnerTests',
  );
}