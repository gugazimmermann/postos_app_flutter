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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgLVNLxpjghlIF6Mw3k8p7w3Wn3UEo_N8',
    appId: '1:78606081651:android:05d7a7ff59de6f9c181406',
    messagingSenderId: '78606081651',
    projectId: 'touch-sistemas--postos',
    storageBucket: 'touch-sistemas--postos.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDwOulYzCE7Yjr2HYvP1b-vYr4Tmr9AMCQ',
    appId: '1:78606081651:ios:038124a491017def181406',
    messagingSenderId: '78606081651',
    projectId: 'touch-sistemas--postos',
    storageBucket: 'touch-sistemas--postos.appspot.com',
    androidClientId: '78606081651-efapun3tepccosv9pcapndc56o9iagaq.apps.googleusercontent.com',
    iosClientId: '78606081651-1sjv111ji4vvvocctk8macj7po03kq6t.apps.googleusercontent.com',
    iosBundleId: 'br.com.touchsistemas.app',
  );
}
