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
    apiKey: 'AIzaSyDRyfgREHyjwWxQ1OVtdut-RGpI2iTQZd0',
    appId: '1:146952619766:web:5ca65caf1567c28b2b8ed7',
    messagingSenderId: '146952619766',
    projectId: 'untitled-2832f',
    authDomain: 'untitled-2832f.firebaseapp.com',
    databaseURL: 'https://untitled-2832f-default-rtdb.firebaseio.com',
    storageBucket: 'untitled-2832f.appspot.com',
    measurementId: 'G-N6E5W533RG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxtk_PN9Ou5gnF9lhBwIvfHgLR5UL5ceE',
    appId: '1:146952619766:android:8647717e87ef37db2b8ed7',
    messagingSenderId: '146952619766',
    projectId: 'untitled-2832f',
    databaseURL: 'https://untitled-2832f-default-rtdb.firebaseio.com',
    storageBucket: 'untitled-2832f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXIQA15Z5rapqtfouRji800bEDSYagonQ',
    appId: '1:146952619766:ios:96121589adcec92d2b8ed7',
    messagingSenderId: '146952619766',
    projectId: 'untitled-2832f',
    databaseURL: 'https://untitled-2832f-default-rtdb.firebaseio.com',
    storageBucket: 'untitled-2832f.appspot.com',
    androidClientId: '146952619766-d0f5d066b7vb1ept43m0ctq3rgcspiek.apps.googleusercontent.com',
    iosClientId: '146952619766-oe04136fscs8alaf1t1hq4ftmfi3kf0f.apps.googleusercontent.com',
    iosBundleId: 'com.example.untitledApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBXIQA15Z5rapqtfouRji800bEDSYagonQ',
    appId: '1:146952619766:ios:96121589adcec92d2b8ed7',
    messagingSenderId: '146952619766',
    projectId: 'untitled-2832f',
    databaseURL: 'https://untitled-2832f-default-rtdb.firebaseio.com',
    storageBucket: 'untitled-2832f.appspot.com',
    androidClientId: '146952619766-d0f5d066b7vb1ept43m0ctq3rgcspiek.apps.googleusercontent.com',
    iosClientId: '146952619766-oe04136fscs8alaf1t1hq4ftmfi3kf0f.apps.googleusercontent.com',
    iosBundleId: 'com.example.untitledApp',
  );
}
