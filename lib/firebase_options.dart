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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAJaVoQ2j3sCt1jB_ARfATzrj5ztragbfc',
    appId: '1:1060028284769:web:6783096534966d800b8f20',
    messagingSenderId: '1060028284769',
    projectId: 'englishfirmversion1point1',
    authDomain: 'englishfirmversion1point1.firebaseapp.com',
    storageBucket: 'englishfirmversion1point1.firebasestorage.app',
    measurementId: 'G-BW6YFD8TLR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrESGTbYFtIuK6xvHF2Kw-Q0qCzOgi6JM',
    appId: '1:1060028284769:android:9e1e2d02130124040b8f20',
    messagingSenderId: '1060028284769',
    projectId: 'englishfirmversion1point1',
    storageBucket: 'englishfirmversion1point1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDHGgXoHKLgze7utKNMfMZeBnZ4tB9Lgt8',
    appId: '1:1060028284769:ios:00ba6b5d514bf3f80b8f20',
    messagingSenderId: '1060028284769',
    projectId: 'englishfirmversion1point1',
    storageBucket: 'englishfirmversion1point1.firebasestorage.app',
    iosBundleId: 'com.example.version1point1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDHGgXoHKLgze7utKNMfMZeBnZ4tB9Lgt8',
    appId: '1:1060028284769:ios:00ba6b5d514bf3f80b8f20',
    messagingSenderId: '1060028284769',
    projectId: 'englishfirmversion1point1',
    storageBucket: 'englishfirmversion1point1.firebasestorage.app',
    iosBundleId: 'com.example.version1point1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAJaVoQ2j3sCt1jB_ARfATzrj5ztragbfc',
    appId: '1:1060028284769:web:e0fb50c7c9b34a8e0b8f20',
    messagingSenderId: '1060028284769',
    projectId: 'englishfirmversion1point1',
    authDomain: 'englishfirmversion1point1.firebaseapp.com',
    storageBucket: 'englishfirmversion1point1.firebasestorage.app',
    measurementId: 'G-C107ER9WJH',
  );
}
