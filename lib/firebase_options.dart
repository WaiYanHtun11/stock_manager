
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
    apiKey: 'AIzaSyASBD3qcEUJLqz-KouSzZ_bPbiTZOG3mec',
    appId: '1:66744714206:web:12348da18cf9790368134f',
    messagingSenderId: '66744714206',
    projectId: 'stock-manager-4a814',
    authDomain: 'stock-manager-4a814.firebaseapp.com',
    storageBucket: 'stock-manager-4a814.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAEvW5byrTmW_q1SggNbL7-nRCbPWzeFMs',
    appId: '1:66744714206:android:81d1bade6ce160c768134f',
    messagingSenderId: '66744714206',
    projectId: 'stock-manager-4a814',
    storageBucket: 'stock-manager-4a814.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBN5EZfvov75hvbwqIKN5cl4bNi3qKccg8',
    appId: '1:66744714206:ios:7f0f0f20323d994268134f',
    messagingSenderId: '66744714206',
    projectId: 'stock-manager-4a814',
    storageBucket: 'stock-manager-4a814.appspot.com',
    iosBundleId: 'com.llpmm.stockManager',
  );

}