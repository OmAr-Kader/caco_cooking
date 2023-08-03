// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {

  static FirebaseOptions? get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    authDomain: '',
    databaseURL: '',
    storageBucket: '',
    androidClientId: CLIENT_ID_WEB,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    authDomain: '',
    databaseURL: '',
    storageBucket: '',
    androidClientId: CLIENT_ID_ANDROID,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    authDomain: '',
    databaseURL: '',
    storageBucket: '',
    iosClientId: '',
    iosBundleId: '',
  );
}

const String CLIENT_ID_WEB = '';
const String CLIENT_SECRET_WEB = '';

const String CLIENT_ID_ANDROID = '';


String get FETCH_CLIENT_ID {
  if (kIsWeb) {
    return CLIENT_ID_WEB;
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return CLIENT_ID_ANDROID;
    default:
      throw CLIENT_ID_ANDROID;
  }
}