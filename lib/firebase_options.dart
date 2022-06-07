// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD6kxFOKpLIwAHkZ0oQJUh6QGVxySUtXGA',
    appId: '1:598894085307:web:51499fa1494085d865559e',
    messagingSenderId: '598894085307',
    projectId: 'completr-3ceac',
    authDomain: 'completr-3ceac.firebaseapp.com',
    storageBucket: 'completr-3ceac.appspot.com',
    measurementId: 'G-DM4GEJLVR4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCy0vSChwMLXtM5ktyrHTwDnfvmGKXBLhA',
    appId: '1:598894085307:android:500893149f0ee93a65559e',
    messagingSenderId: '598894085307',
    projectId: 'completr-3ceac',
    storageBucket: 'completr-3ceac.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCK01YnfK_UrraLli33TbPdu406PfU20v8',
    appId: '1:598894085307:ios:29ee644d143e27be65559e',
    messagingSenderId: '598894085307',
    projectId: 'completr-3ceac',
    storageBucket: 'completr-3ceac.appspot.com',
    iosClientId: '598894085307-scntev1efhteugeq6541t2b6oacv0qn3.apps.googleusercontent.com',
    iosBundleId: 'com.potato.completr',
  );
}
