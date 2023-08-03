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
    apiKey: 'AIzaSyA8GEDqzq85otlTSwsiodKE_YjGg8BVHWA',
    appId: '1:500500972728:android:ff0ebceb6976402006204d',
    messagingSenderId: '500500972728',
    projectId: 'caco-cooking',
    authDomain: 'caco-cooking.firebaseapp.com',
    databaseURL: 'https://caco-cooking-default-rtdb.firebaseio.com',
    storageBucket: 'caco-cooking.appspot.com',
    androidClientId: CLIENT_ID_WEB,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8GEDqzq85otlTSwsiodKE_YjGg8BVHWA',
    appId: '1:500500972728:android:ff0ebceb6976402006204d',
    messagingSenderId: '500500972728',
    projectId: 'caco-cooking',
    authDomain: 'caco-cooking.firebaseapp.com',
    databaseURL: 'https://caco-cooking-default-rtdb.firebaseio.com',
    storageBucket: 'caco-cooking.appspot.com',
    androidClientId: CLIENT_ID_ANDROID,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8GEDqzq85otlTSwsiodKE_YjGg8BVHWA',
    appId: '1:500500972728:android:ff0ebceb6976402006204d',
    messagingSenderId: '500500972728',
    projectId: 'caco-cooking',
    authDomain: 'caco-cooking.firebaseapp.com',
    databaseURL: 'https://caco-cooking-default-rtdb.firebaseio.com',
    storageBucket: 'caco-cooking.appspot.com',
    iosClientId: '1045475764615-sh6bdtfvq5gi9hdi9elu247v7usqsvpl.apps.googleusercontent.com',
    iosBundleId: 'com.mrezys',
  );
}

const String CLIENT_ID_WEB = '500500972728-pgjuors8fuahogne9f9qe6a9rb9kelrp.apps.googleusercontent.com';
const String CLIENT_SECRET_WEB = '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';
//AIzaSyCGC0Pz88R8KdtWBhXgGoZt5BWHxoR9Lxk

//const String CLIENT_ID_ANDROID = '500500972728-4qde159q5ns9mou6v32sk2k4qhn5eiat.apps.googleusercontent.com';
const String CLIENT_ID_ANDROID = '500500972728-8qrsk6h9m5gva6t0m7ajtsest12ohqsl.apps.googleusercontent.com';
//const String CLIENT_ID_ANDROID = 'AIzaSyA8GEDqzq85otlTSwsiodKE_YjGg8BVHWA.apps.googleusercontent.com';
//AIzaSyA8GEDqzq85otlTSwsiodKE_YjGg8BVHWA

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